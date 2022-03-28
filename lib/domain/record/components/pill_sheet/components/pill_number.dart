import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';

class PlainPillNumber extends StatelessWidget {
  final int pillNumberIntoPillSheet;

  const PlainPillNumber({Key? key, required this.pillNumberIntoPillSheet})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      "$pillNumberIntoPillSheet",
      style: FontType.smallTitle
          .merge(const TextStyle(color: PilllColors.weekday)),
      textScaleFactor: 1,
    );
  }
}

class SequentialPillNumber extends StatelessWidget {
  final int pageOffset;
  final OffsetPillNumber? offsetPillNumber;
  final int pillNumberIntoPillSheet;

  const SequentialPillNumber(
      {Key? key,
      required this.pageOffset,
      required this.offsetPillNumber,
      required this.pillNumberIntoPillSheet})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var number = pageOffset + pillNumberIntoPillSheet;
    final offsetPillNumber = this.offsetPillNumber;
    if (offsetPillNumber != null) {
      final beginPillNumberOffset = offsetPillNumber.beginPillNumber;
      if (beginPillNumberOffset != null) {
        number += (beginPillNumberOffset - 1);
      }

      final endPillNumberOffset = offsetPillNumber.endPillNumber;
      if (endPillNumberOffset != null) {
        number %= endPillNumberOffset;
      }
    }

    return Text(
      "$number",
      style: FontType.smallTitle
          .merge(const TextStyle(color: PilllColors.weekday)),
      textScaleFactor: 1,
    );
  }
}

class PlainPillDate extends StatelessWidget {
  final DateTime date;

  const PlainPillDate({Key? key, required this.date}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      DateTimeFormatter.monthAndDay(date),
      style: FontType.smallTitle
          .merge(const TextStyle(color: PilllColors.weekday)),
      textScaleFactor: 1,
    );
  }
}

class MenstruationPillNumber extends StatelessWidget {
  final int pillNumberIntoPillSheet;

  const MenstruationPillNumber(
      {Key? key, required this.pillNumberIntoPillSheet})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      "$pillNumberIntoPillSheet",
      style: FontType.smallTitle
          .merge(const TextStyle(color: PilllColors.primary)),
      textScaleFactor: 1,
    );
  }
}

class MenstruationSequentialPillNumber extends StatelessWidget {
  final int pageOffset;
  final OffsetPillNumber? offsetPillNumber;
  final int pillNumberIntoPillSheet;

  const MenstruationSequentialPillNumber(
      {Key? key,
      required this.pageOffset,
      required this.offsetPillNumber,
      required this.pillNumberIntoPillSheet})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var number = pageOffset + pillNumberIntoPillSheet;
    final offsetPillNumber = this.offsetPillNumber;
    if (offsetPillNumber != null) {
      final beginPillNumberOffset = offsetPillNumber.beginPillNumber;
      if (beginPillNumberOffset != null) {
        number += (beginPillNumberOffset - 1);
      }

      final endPillNumberOffset = offsetPillNumber.endPillNumber;
      if (endPillNumberOffset != null) {
        number %= endPillNumberOffset;
      }
    }

    return Text(
      "$number",
      style: FontType.smallTitle
          .merge(const TextStyle(color: PilllColors.primary)),
      textScaleFactor: 1,
    );
  }
}

class MenstruationPillDate extends StatelessWidget {
  final DateTime date;
  const MenstruationPillDate({Key? key, required this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      DateTimeFormatter.monthAndDay(date),
      style: FontType.smallTitle
          .merge(const TextStyle(color: PilllColors.primary)),
      textScaleFactor: 1,
    );
  }
}
