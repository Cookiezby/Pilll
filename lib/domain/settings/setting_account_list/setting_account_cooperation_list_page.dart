import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/components/page/hud.dart';
import 'package:pilll/domain/settings/setting_account_list/components/delete_user_button.dart';
import 'package:pilll/domain/settings/setting_account_list/setting_account_cooperation_list_page_store.dart';
import 'package:pilll/entity/link_account_type.dart';
import 'package:pilll/error/universal_error_page.dart';
import 'package:pilll/signin/signin_sheet.dart';
import 'package:pilll/signin/signin_sheet_state.dart';

class SettingAccountCooperationListPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(settingAccountCooperationListProvider.notifier);
    final state = ref.watch(settingAccountCooperationListProvider);
    return HUD(
      shown: state.isLoading,
      child: UniversalErrorPage(
        error: state.exception,
        reload: () => store.reset(),
        child: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              backgroundColor: PilllColors.background,
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text('アカウント設定', style: TextColorStyle.main),
                backgroundColor: PilllColors.white,
              ),
              body: Container(
                child: ListView(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 16, left: 15, right: 16),
                      child: Text(
                        "アカウント登録",
                        style: FontType.assisting.merge(TextColorStyle.primary),
                      ),
                    ),
                    SettingAccountCooperationRow(
                      accountType: LinkAccountType.apple,
                      isLinked: () => state.isLinkedApple,
                      onTap: () async {
                        if (state.isLinkedApple) {
                          return;
                        }
                        _showSigninSheet(context);
                      },
                    ),
                    const Divider(indent: 16),
                    SettingAccountCooperationRow(
                      accountType: LinkAccountType.google,
                      isLinked: () => state.isLinkedGoogle,
                      onTap: () async {
                        if (state.isLinkedGoogle) {
                          return;
                        }
                        _showSigninSheet(context);
                      },
                    ),
                    const Divider(indent: 16),
                    DeleteUserButton(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _showSigninSheet(BuildContext context) {
    showSigninSheet(
      context,
      SigninSheetStateContext.setting,
      (accountType) async {
        final snackBarDuration = const Duration(seconds: 1);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: snackBarDuration,
            content: Text("${accountType.providerName}で登録しました"),
          ),
        );
        await Future.delayed(snackBarDuration);
      },
    );
  }
}

extension SettingAccountCooperationListPageRoute
    on SettingAccountCooperationListPage {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: "SettingAccountCooperationListPage"),
      builder: (_) => SettingAccountCooperationListPage(),
    );
  }
}

class SettingAccountCooperationRow extends StatelessWidget {
  final LinkAccountType accountType;
  final bool Function() isLinked;
  final Future<void> Function() onTap;

  SettingAccountCooperationRow({
    required this.accountType,
    required this.isLinked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(accountType.loginContentName, style: FontType.listRow),
        trailing: _trailing(),
        horizontalTitleGap: 4,
        onTap: () async {
          if (isLinked()) {
            return;
          }
          await onTap();
        });
  }

  Widget _trailing() {
    if (isLinked()) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset("images/checkmark_green.svg"),
          const SizedBox(width: 6),
          Text("連携済み",
              style: FontType.assisting.merge(TextColorStyle.darkGray)),
        ],
      );
    } else {
      return SizedBox(
        height: 40,
        width: 88,
        child: SmallAppOutlinedButton(
          onPressed: () async {
            onTap();
          },
          text: "連携する",
        ),
      );
    }
  }
}
