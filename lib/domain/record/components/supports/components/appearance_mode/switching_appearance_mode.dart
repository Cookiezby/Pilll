import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/record/components/supports/components/appearance_mode/select_appearance_mode_modal.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/entity/setting.dart';

class SwitchingAppearanceMode extends StatelessWidget {
  final RecordPageStore store;
  final PillSheetAppearanceMode mode;
  const SwitchingAppearanceMode({
    Key? key,
    required this.store,
    required this.mode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(children: [
        Text(
          "表示モード",
          style: TextStyle(
            color: TextColor.main,
            fontSize: 12,
            fontFamily: FontFamily.japanese,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 6),
        SvgPicture.asset("images/switching_appearance_mode.svg"),
      ]),
      onTap: () {
        analytics.logEvent(name: "did_tapped_record_page_appearance_mode");
        showSelectAppearanceModeModal(context);
      },
    );
  }
}
