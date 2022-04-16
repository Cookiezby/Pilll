import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/domain/record/components/header/today_taken_pill_number.dart';
import 'package:pilll/domain/record/record_page_state.codegen.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/domain/settings/today_pill_number/setting_today_pill_number_page.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/util/formatter/date_time_formatter.dart';
import 'package:flutter/material.dart';

abstract class RecordPageInformationHeaderConst {
  static final double height = 130;
}

class RecordPageInformationHeader extends StatelessWidget {
  final DateTime today;
  final PillSheetGroup? pillSheetGroup;
  final Setting setting;
  final RecordPageState state;
  final RecordPageStore store;
  const RecordPageInformationHeader({
    Key? key,
    required this.today,
    required this.pillSheetGroup,
    required this.setting,
    required this.state,
    required this.store,
  }) : super(key: key);

  String _formattedToday() => DateTimeFormatter.monthAndDay(this.today);
  String _todayWeekday() => DateTimeFormatter.weekday(this.today);

  @override
  Widget build(BuildContext context) {
    final pillSheetGroup = this.pillSheetGroup;
    final activedPillSheet = pillSheetGroup?.activedPillSheet;
    final setting = this.setting;

    return Container(
      height: RecordPageInformationHeaderConst.height,
      child: Column(
        children: <Widget>[
          const SizedBox(height: 34),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _todayWidget(),
              const SizedBox(width: 28),
              Container(
                height: 64,
                child: const VerticalDivider(
                  width: 10,
                  color: PilllColors.divider,
                ),
              ),
              const SizedBox(width: 28),
              TodayTakenPillNumber(
                  pillSheetGroup: pillSheetGroup,
                  setting: setting,
                  onPressed: () {
                    analytics.logEvent(
                        name: "tapped_record_information_header");
                    if (activedPillSheet != null &&
                        pillSheetGroup != null &&
                        !pillSheetGroup.isDeactived) {
                      Navigator.of(context).push(
                        SettingTodayPillNumberPageRoute.route(
                          setting: setting,
                          pillSheetGroup: pillSheetGroup,
                          activedPillSheet: activedPillSheet,
                          isTrial: state.isTrial,
                          isPremium: state.isPremium,
                        ),
                      );
                    }
                  }),
            ],
          ),
        ],
      ),
    );
  }

  Center _todayWidget() {
    return Center(
      child: Text(
        "${_formattedToday()} (${_todayWeekday()})",
        style: FontType.xBigNumber.merge(TextColorStyle.gray),
      ),
    );
  }
}
