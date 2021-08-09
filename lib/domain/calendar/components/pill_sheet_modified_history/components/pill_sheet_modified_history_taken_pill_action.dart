import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/pill_sheet_modified_history_taken_action_layout.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';

class PillSheetModifiedHistoryTakenPillAction extends StatelessWidget {
  final DateTime createdAt;
  final TakenPillValue? value;
  final PillSheet afterPillSheet;

  const PillSheetModifiedHistoryTakenPillAction({
    Key? key,
    required this.createdAt,
    required this.value,
    required this.afterPillSheet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final value = this.value;
    if (value == null) {
      return Container();
    }
    final time = DateTimeFormatter.hourAndMinute(value.afterLastTakenDate);
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            PillSheetModifiedHistoryDate(
              createdAt: createdAt,
              pillNumber: value.afterLastTakenPillNumber,
            ),
            Container(
              width: PillSheetModifiedHistoryTakenActionLayoutWidths.takenTime,
              child: Text(
                time,
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: TextColor.main,
                  fontSize: 15,
                  fontFamily: FontFamily.number,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            Container(
              width: PillSheetModifiedHistoryTakenActionLayoutWidths.takenMark,
              padding: EdgeInsets.only(left: 8),
              child: Stack(
                  children: List.generate(
                      value.afterLastTakenPillNumber -
                          (value.beforeLastTakenPillNumber ?? 1), (index) {
                final child = _inRestDuration(
                        afterPillSheet, value.afterLastTakenPillNumber - index)
                    ? SvgPicture.asset("images/dot_o.svg")
                    : SvgPicture.asset("images/o.svg");
                if (index == 0) {
                  return Align(
                    alignment: Alignment.center,
                    child: child,
                  );
                } else {
                  if (index % 2 == 0) {
                    return Align(
                      alignment: Alignment(-0.1 * index, 0),
                      child: child,
                    );
                  } else {
                    return Align(
                      alignment: Alignment(0.1 * index, 0),
                      child: child,
                    );
                  }
                }
              }).toList()),
            ),
          ],
        ),
      ),
    );
  }

  bool _inRestDuration(PillSheet pillSheet, int pillNumber) {
    return pillSheet.pillSheetType.dosingPeriod >= pillNumber;
  }
}
