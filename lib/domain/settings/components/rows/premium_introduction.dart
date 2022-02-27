import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/domain/premium_introduction/premium_introduction_sheet.dart';
import 'package:pilll/domain/premium_trial/premium_trial_complete_modal.dart';
import 'package:pilll/domain/premium_trial/premium_trial_modal.dart';

class PremiumIntroductionRow extends StatelessWidget {
  final bool isPremium;
  final DateTime? trialDeadlineDate;

  const PremiumIntroductionRow({
    Key? key,
    required this.isPremium,
    required this.trialDeadlineDate,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        analytics.logEvent(name: "tapped_premium_introduction_row");
        if (trialDeadlineDate == null) {
          showPremiumTrialModal(context, () {
            showPremiumTrialCompleteModalPreDialog(context);
          });
        } else {
          showPremiumIntroductionSheet(context);
        }
      },
      title: Row(
        children: [
          SvgPicture.asset("images/crown.svg", width: 24),
          const SizedBox(width: 8),
          const Text("プレミアムプランを見る", style: FontType.listRow),
        ],
      ),
    );
  }
}
