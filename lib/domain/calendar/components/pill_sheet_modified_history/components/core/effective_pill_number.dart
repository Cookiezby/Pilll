import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.dart';

class EffectivePillNumber extends StatelessWidget {
  const EffectivePillNumber({
    Key? key,
    required this.effectivePillNumber,
  }) : super(key: key);

  final String effectivePillNumber;

  @override
  Widget build(BuildContext context) {
    return Text(
      "$effectivePillNumber",
      style: TextStyle(
        color: TextColor.main,
        fontFamily: FontFamily.japanese,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      textAlign: TextAlign.start,
    );
  }
}

abstract class PillSheetModifiedHistoryDateEffectivePillNumber {
  static String hyphen() => "-";
  static String taken(TakenPillValue value) {
    final before = value.beforeLastTakenPillNumber;
    final after = value.afterLastTakenPillNumber;
    if (before == (after - 1)) {
      return "$after番";
    }
    return "${before + 1}-$after番";
  }

  static String autoTaken(AutomaticallyRecordedLastTakenDateValue value) {
    final before = value.beforeLastTakenPillNumber;
    final after = value.afterLastTakenPillNumber;
    if ((before + 1) == after) {
      return "$after番";
    }
    return "${before + 1}-$after番";
  }

  static String revert(RevertTakenPillValue value) {
    final before = value.beforeLastTakenPillNumber;
    final after = value.afterLastTakenPillNumber;
    if (before == (after + 1)) {
      return "$before番";
    }
    return "$before-${after + 1}番";
  }

  static String changed(ChangedPillNumberValue value) =>
      "${value.beforeTodayPillNumber}→${value.afterTodayPillNumber}番";

  static String pillSheetCount(List<String> pillSheetIDs) =>
      pillSheetIDs.isNotEmpty ? "${pillSheetIDs.length}枚" : hyphen();
}
