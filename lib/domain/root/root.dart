import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/page/ok_dialog.dart';
import 'package:pilll/domain/initial_setting/pill_sheet_group/initial_setting_pill_sheet_group_page.dart';
import 'package:pilll/domain/initial_setting/pill_type/initial_setting_pill_category_type_page.dart';
import 'package:pilll/entity/config.codegen.dart';
import 'package:pilll/entity/user.codegen.dart';
import 'package:pilll/performance.dart';
import 'package:pilll/service/auth.dart';
import 'package:pilll/database/database.dart';
import 'package:pilll/domain/home/home_page.dart';
import 'package:pilll/entity/user_error.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/error/template.dart';
import 'package:pilll/error/universal_error_page.dart';
import 'package:pilll/error_log.dart';
import 'package:pilll/service/purchase.dart';
import 'package:pilll/service/user.dart';
import 'package:pilll/util/platform/platform.dart';
import 'package:pilll/util/shared_preference/keys.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pilll/util/version/version.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

GlobalKey<RootState> rootKey = GlobalKey();

class Root extends StatefulWidget {
  Root({Key? key}) : super(key: key);

  @override
  RootState createState() => RootState();
}

enum ScreenType { home, initialSetting, forceUpdate }

class RootState extends State<Root> {
  final String _traceUUID = const Uuid().v4();

  dynamic _error;
  ScreenType? screenType;
  showHome() {
    setState(() {
      screenType = ScreenType.home;
    });
  }

  reload() {
    setState(() {
      screenType = null;
      _error = null;
      _decideScreenType();
    });
  }

  @override
  void initState() {
    _decideScreenType();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (screenType == null && _error == null) {
      return ScaffoldIndicator();
    }
    if (screenType == ScreenType.forceUpdate) {
      Future.microtask(() async {
        await showOKDialog(context,
            title: "アプリをアップデートしてください",
            message:
                "お使いのアプリのバージョンのアップデートをお願いしております。$storeNameから最新バージョンにアップデートしてください",
            ok: () async {
          await launch(storeURL, forceSafariVC: false, forceWebView: false);
        });
      });
      return ScaffoldIndicator();
    }

    return UniversalErrorPage(
      error: _error,
      reload: () => reload(),
      child: () {
        switch (screenType) {
          case ScreenType.home:
            return HomePage(key: homeKey);
          case ScreenType.initialSetting:
            return InitialSettingPillSheetGroupPageRoute.screen();
          default:
            return ScaffoldIndicator();
        }
      }(),
    );
  }

  Trace _trace({required String name, required String uuid}) {
    final trace = performance.newTrace(name);
    trace.putAttribute("uuid", uuid);
    return trace;
  }

// Return false: should not force update
// Return true: should force update
  Future<bool> _checkForceUpdate() async {
    final forceUpdateTrace = _trace(name: "forceUpdate", uuid: _traceUUID);
    await forceUpdateTrace.start();

    final doc = await FirebaseFirestore.instance.doc("/globals/config").get();
    final config = Config.fromJson(doc.data() as Map<String, dynamic>);
    final packageVersion = await Version.fromPackage();

    await forceUpdateTrace.stop();

    return packageVersion
        .isLessThan(Version.parse(config.minimumSupportedAppVersion));
  }

  Future<FirebaseAuth.User> _signIn() async {
    final signInTrace = _trace(name: "signInTrace", uuid: _traceUUID);
    await signInTrace.start();
    final firebaseUser = await cachedUserOrSignInAnonymously();
    await signInTrace.stop();

    unawaited(FirebaseCrashlytics.instance.setUserIdentifier(firebaseUser.uid));
    unawaited(firebaseAnalytics.setUserId(id: firebaseUser.uid));
    unawaited(initializePurchase(firebaseUser.uid));

    return firebaseUser;
  }

  Future<ScreenType> _screenType() async {
    final sharedPreferences = await SharedPreferences.getInstance();

    bool? didEndInitialSetting =
        sharedPreferences.getBool(BoolKey.didEndInitialSetting);
    if (didEndInitialSetting == null) {
      return ScreenType.initialSetting;
    }
    if (!didEndInitialSetting) {
      return ScreenType.initialSetting;
    }

    return screenType = ScreenType.home;
  }

  Future<User> _mutateUserWithLaunchInfoAnd(
      FirebaseAuth.User firebaseUser) async {
    final userService = UserService(DatabaseConnection(firebaseUser.uid));
    userService.saveUserLaunchInfo();

    final user = await userService.prepare(firebaseUser.uid);
    unawaited(userService.temporarySyncronizeDiscountEntitlement(user));

    return user;
  }

  Future<ScreenType?> _screenTypeForLegacyUser(
      FirebaseAuth.User firebaseUser, User user) async {
    if (!user.migratedFlutter) {
      final userService = UserService(DatabaseConnection(firebaseUser.uid));
      await userService.deleteSettings();
      await userService.setFlutterMigrationFlag();
      return ScreenType.initialSetting;
    } else if (user.setting == null) {
      return screenType = ScreenType.initialSetting;
    }
    return null;
  }

  // forceUpdate -> signIn -> decide initial setting or home screen -> after effect: mutate user launch info to db and salvage old version user
  // save launch app time, Keep last of `after effect: mutate user launch info to db and salvage old version user`
  void _decideScreenType() {
    Future(() async {
      final launchTrace = _trace(name: "appLaunch", uuid: _traceUUID);
      await launchTrace.start();

      try {
        final shouldForceUpdate = await _checkForceUpdate();
        if (shouldForceUpdate) {
          setState(() {
            this.screenType = ScreenType.forceUpdate;
          });
        } else {
          final firebaseUser = await _signIn();

          final screenType = await _screenType();
          setState(() {
            this.screenType = screenType;
          });

          // NOTE: Below code contains backward-compatible logic from version 1.3.2
          // screenType is determined if necessary, but since it is a special pattern. So, it is determined last
          final user = await _mutateUserWithLaunchInfoAnd(firebaseUser);
          final screenTypeForLegacyUser =
              await _screenTypeForLegacyUser(firebaseUser, user);
          if (screenTypeForLegacyUser != null) {
            setState(() {
              this.screenType = screenTypeForLegacyUser;
            });
          }
        }
      } catch (error, stackTrace) {
        errorLogger.recordError(error, stackTrace);

        setState(() {
          this._error = UserDisplayedError(
              ErrorMessages.connection + "\n" + "起動処理でエラーが発生しました");
        });
      } finally {
        await launchTrace.stop();
      }
    });
  }
}
