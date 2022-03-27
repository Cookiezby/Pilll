import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:url_launcher/url_launcher.dart';

class InvalidAlreadyTakenPillDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.only(left: 24, right: 24, top: 4, bottom: 24),
      actionsPadding: const EdgeInsets.only(left: 24, right: 24, bottom: 32),
      titlePadding: const EdgeInsets.only(top: 32),
      title: SvgPicture.asset("images/alert_24.svg", width: 24, height: 24),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "今日飲むピルが服用済みの場合\n休薬できません",
            style: FontType.subTitle.merge(TextColorStyle.main),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SvgPicture.asset("images/invalid_rest_duration.svg"),
          const SizedBox(
            height: 15,
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(height: 1.7),
              children: [
                TextSpan(
                  text: "今日飲むピルを未服用にしてから",
                  style: FontType.assistingBold.merge(TextColorStyle.main),
                ),
                TextSpan(
                  text: "休薬してください。今日以外の日から休薬したい場合は下記を参考にしてください。",
                  style: FontType.assisting.merge(TextColorStyle.main),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        AppOutlinedButton(
          onPressed: () async {
            analytics.logEvent(name: "invalid_already_taken_pill_faq");
            launch(
                "https://pilll.wraptas.site/467128e667ae4d6cbff4d61ee370cce5");
          },
          text: "休薬機能の使い方を見る",
        ),
        Center(
          child: AlertButton(
            text: "閉じる",
            onPressed: () async {
              analytics.logEvent(name: "invalid_already_taken_pill_close");
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }
}

showInvalidAlreadyTakenPillDialog(
  BuildContext context,
) {
  analytics.setCurrentScreen(screenName: "InvalidAlreadyTakenPillDialog");
  showDialog(
    context: context,
    builder: (context) => InvalidAlreadyTakenPillDialog(),
  );
}
