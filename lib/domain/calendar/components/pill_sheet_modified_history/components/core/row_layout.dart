import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';

class RowLayout extends StatelessWidget {
  final Widget day;
  final Widget effectiveNumbers;
  final Widget time;
  final Widget? takenPillActionOList;

  const RowLayout({
    Key? key,
    required this.day,
    required this.effectiveNumbers,
    required this.time,
    required this.takenPillActionOList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final takenPillActionOList = this.takenPillActionOList;
    return Row(
      children: [
        day,
        SizedBox(width: 8),
        Container(
          height: 26,
          child: VerticalDivider(
            color: PilllColors.divider,
            width: 0.5,
          ),
        ),
        SizedBox(width: 8),
        Container(
          width: 79,
          child: effectiveNumbers,
        ),
        SizedBox(width: 8),
        Expanded(
          child: time,
        ),
        SizedBox(width: 8),
        if (takenPillActionOList != null) ...[
          Container(
            width: 57,
            child: takenPillActionOList,
          ),
        ],
      ],
    );
  }
}
