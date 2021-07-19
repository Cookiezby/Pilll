import 'package:pilll/domain/calendar/monthly_calendar_state.dart';
import 'package:pilll/components/organisms/calendar/calendar_band_model.dart';
import 'package:pilll/components/organisms/calendar/weekly_calendar.dart';
import 'package:pilll/domain/record/weekday_badge.dart';
import 'package:pilll/entity/diary.dart';
import 'package:pilll/entity/weekday.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

abstract class CalendarConstants {
  static final double tileHeight = 66;
  static const int constantLineCount = 6;
}

class MonthlyCalendarLayout extends StatelessWidget {
  // NOTE: If return null fill container at bottom
  final Widget? Function(BuildContext, int) weeklyCalendarBuilder;

  const MonthlyCalendarLayout({
    Key? key,
    required this.weeklyCalendarBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(
              Weekday.values.length,
              (index) => Expanded(
                    child: WeekdayBadge(
                      weekday: Weekday.values[index],
                    ),
                  )),
        ),
        Divider(height: 1),
        ...List.generate(CalendarConstants.constantLineCount, (offset) {
          final weeklyCalendar = weeklyCalendarBuilder(context, offset);
          if (weeklyCalendar == null) {
            return Container(height: CalendarConstants.tileHeight);
          }
          return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [weeklyCalendar, Divider(height: 1)]);
        }),
      ],
    );
  }
}

class Calendar extends HookWidget {
  final MonthlyCalendarState calendarState;
  final List<CalendarBandModel> bandModels;
  final List<Diary> diaries;
  final Function(DateTime, List<Diary>) onTap;
  final double horizontalPadding;

  const Calendar({
    Key? key,
    required this.calendarState,
    required this.bandModels,
    required this.diaries,
    required this.onTap,
    required this.horizontalPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(
              Weekday.values.length,
              (index) => Expanded(
                    child: WeekdayBadge(
                      weekday: Weekday.values[index],
                    ),
                  )),
        ),
        Divider(height: 1),
        ...List.generate(CalendarConstants.constantLineCount, (_line) {
          final line = _line + 1;
          if (calendarState.weeklineCount() <
                  CalendarConstants.constantLineCount &&
              line == CalendarConstants.constantLineCount) {
            return Container(height: CalendarConstants.tileHeight);
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CalendarWeekdayLine(
                diaries: diaries,
                calendarState: calendarState.weeklyCalendarState(line),
                bandModels: bandModels,
                horizontalPadding: horizontalPadding,
                onTap: (weeklyCalendarState, date) => onTap(date, diaries),
              ),
              Divider(height: 1),
            ],
          );
        }),
      ],
    );
  }
}
