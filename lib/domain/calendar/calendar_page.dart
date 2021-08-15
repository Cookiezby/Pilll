import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/domain/calendar/calendar_state.dart';
import 'package:pilll/domain/calendar/components/calendar_card.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/calendar/components/calendar_help.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/pill_sheet_modified_history_card.dart';
import 'package:pilll/domain/home/home_page.dart';
import 'package:pilll/domain/calendar/calendar_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class CalendarPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      final store = watch(calendarPageStateProvider);
      final state = watch(calendarPageStateProvider.state);
      homeKey.currentState?.diaries = state.diariesForMonth;
      if (state.shouldShowIndicator) {
        return ScaffoldIndicator();
      }
      final ItemScrollController itemScrollController = ItemScrollController();
      final ItemPositionsListener itemPositionsListener =
          ItemPositionsListener.create();
      itemPositionsListener.itemPositions.addListener(() {
        final index = itemPositionsListener.itemPositions.value.last.index;
        store.updateCurrentCalendarIndex(index);
      });
      return Scaffold(
        backgroundColor: PilllColors.background,
        appBar: AppBar(
          leading: AppBarTextActionButton(
              onPressed: () {
                analytics.logEvent(name: "calendar_to_today_pressed");
                store.updateCurrentCalendarIndex(state.todayCalendarIndex);
                itemScrollController.scrollTo(
                    index: state.todayCalendarIndex,
                    duration: Duration(milliseconds: 300));
              },
              text: "今日"),
          actions: [
            IconButton(
              icon: SvgPicture.asset("images/help.svg"),
              onPressed: () {
                analytics.logEvent(name: "pressed_calendar_help");
                showDialog(
                    context: context,
                    builder: (_) {
                      return CalendarHelpPage();
                    });
              },
            ),
          ],
          title: CalendarModifyMonth(
              state: state,
              itemScrollController: itemScrollController,
              store: store),
          centerTitle: true,
          elevation: 0,
          backgroundColor: PilllColors.white,
        ),
        extendBodyBehindAppBar: true,
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 444,
                child: ScrollablePositionedList.builder(
                  itemScrollController: itemScrollController,
                  initialScrollIndex: state.currentCalendarIndex,
                  scrollDirection: Axis.horizontal,
                  physics: PageScrollPhysics(),
                  itemCount: state.calendarDataSource.length,
                  itemPositionsListener: itemPositionsListener,
                  itemBuilder: (context, index) {
                    return CalendarContainer(store: store, state: state);
                  },
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: CalendarPillSheetModifiedHistoryCard(
                  state: CalendarPillSheetModifiedHistoryCardState(
                      state.allPillSheetModifiedHistories),
                ),
              ),
              SizedBox(height: 120),
            ],
          ),
        ),
      );
    });
  }
}

class CalendarContainer extends StatelessWidget {
  const CalendarContainer({
    Key? key,
    required this.store,
    required this.state,
  }) : super(key: key);

  final CalendarPageStateStore store;
  final CalendarPageState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 444,
      width: MediaQuery.of(context).size.width,
      child: CalendarCard(
        state: store.cardState(state.displayMonth),
        diariesForMonth: state.diariesForMonth,
        allBands: state.allBands,
      ),
    );
  }
}

class CalendarModifyMonth extends StatelessWidget {
  const CalendarModifyMonth({
    Key? key,
    required this.state,
    required this.itemScrollController,
    required this.store,
  }) : super(key: key);

  final CalendarPageState state;
  final ItemScrollController itemScrollController;
  final CalendarPageStateStore store;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: SvgPicture.asset("images/arrow_left.svg"),
          onPressed: () {
            final previousMonthIndex = state.currentCalendarIndex - 1;
            itemScrollController.scrollTo(
                index: previousMonthIndex,
                duration: Duration(milliseconds: 300));
            store.updateCurrentCalendarIndex(previousMonthIndex);
            analytics.logEvent(name: "pressed_previous_month", parameters: {
              "current_index": state.currentCalendarIndex,
              "previous_index": previousMonthIndex
            });
          },
        ),
        Text(
          state.displayMonthString,
          style: TextColorStyle.main.merge(FontType.subTitle),
        ),
        IconButton(
          icon: SvgPicture.asset("images/arrow_right.svg"),
          onPressed: () {
            final nextMonthIndex = state.currentCalendarIndex + 1;
            itemScrollController.scrollTo(
                index: nextMonthIndex, duration: Duration(milliseconds: 300));
            store.updateCurrentCalendarIndex(nextMonthIndex);
            analytics.logEvent(name: "pressed_next_month", parameters: {
              "current_index": state.currentCalendarIndex,
              "next_index": nextMonthIndex
            });
          },
        ),
      ],
    );
  }
}
