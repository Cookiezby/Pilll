import 'package:Pilll/main/application/router.dart';
import 'package:Pilll/theme/color.dart';
import 'package:Pilll/theme/text_color.dart';
import 'package:Pilll/util/shared_preference/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Pilll/model/auth_user.dart';
import 'package:provider/provider.dart';
import 'package:Pilll/model/immutable/user.dart' as user;

class Root extends StatefulWidget {
  Root({Key key}) : super(key: key);

  @override
  RootState createState() => RootState();
}

class RootState extends State<Root> {
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().then((app) {
      print("app name is $app.name");
      return FirebaseAuth.instance.signInAnonymously();
    }).then((userCredential) {
      context.read<AuthUser>().userCredential = userCredential;
      return user.User.fetch(userCredential).catchError((error) {
        if (error is user.UserNotFound) {
          return user.User.create(userCredential);
        }
        return FormatException(
            "cause exception when failed fetch and create user");
      });
    }).then((value) {
      return SharedPreferences.getInstance();
    }).then((storage) {
      bool didEndInitialSetting = storage.getBool(BoolKey.didEndInitialSetting);
      if (didEndInitialSetting == null) {
        Navigator.popAndPushNamed(context, Routes.initialSetting);
        return;
      }
      if (!didEndInitialSetting) {
        Navigator.popAndPushNamed(context, Routes.initialSetting);
        return;
      }
      Navigator.popAndPushNamed(context, Routes.main);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PilllColors.background,
      appBar: AppBar(
        title: Text('Pilll'),
        backgroundColor: PilllColors.primary,
      ),
      body: Container(
        child: Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(PilllColors.primary)),
        ),
      ),
    );
  }
}
