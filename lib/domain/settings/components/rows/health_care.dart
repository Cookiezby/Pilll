import 'package:flutter/material.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/molecules/premium_badge.dart';
import 'package:pilll/domain/premium_introduction/premium_introduction_sheet.dart';
import 'package:pilll/domain/premium_trial/premium_trial_complete_modal.dart';
import 'package:pilll/domain/premium_trial/premium_trial_modal.dart';
import 'package:pilll/entity/user_error.dart';
import 'package:pilll/error/error_alert.dart';
import 'package:pilll/error/universal_error_page.dart';
import 'package:pilll/native/health_care.dart';
import 'package:url_launcher/url_launcher.dart';

class HealthCareRow extends StatelessWidget {
  final bool isTrial;
  final bool isPremium;
  final DateTime? trialDeadlineDate;

  const HealthCareRow({
    Key? key,
    required this.isTrial,
    required this.isPremium,
    required this.trialDeadlineDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 9,
      title: Row(
        children: [
          Text("ヘルスケア連携", style: FontType.listRow),
          if (!isPremium) ...[
            SizedBox(width: 8),
            PremiumBadge(),
          ]
        ],
      ),
      subtitle: Text("Pilllで記録した生理記録を自動でヘルスケアに記録できます"),
      onTap: () async {
        analytics.logEvent(
          name: "did_select_health_care_row",
        );

        if (isTrial || isPremium) {
          try {
            if (await isAuthorizedReadAndShareToHealthKitData()) {
              launch(
                  "https://pilll.wraptas.site/c26580878bb74fdba86f1b71e93c7c02");
            } else {
              if (await shouldRequestForAccessToHealthKitData()) {
                await requestWriteMenstrualFlowHealthKitDataPermission();
              }
            }
          } catch (error) {
            if (error is UserDisplayedError) {
              showErrorAlertWithError(context, error);
            } else {
              UniversalErrorPage.of(context).showError(error);
            }
          }
        } else {
          if (trialDeadlineDate == null) {
            showPremiumTrialModal(context, () {
              showPremiumTrialCompleteModalPreDialog(context);
            });
          } else {
            showPremiumIntroductionSheet(context);
          }
        }
      },
    );
  }
}
