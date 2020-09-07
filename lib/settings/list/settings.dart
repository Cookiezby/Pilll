import 'package:Pilll/main/components/pill_sheet_type_select_page.dart';
import 'package:Pilll/main/components/setting_menstruation_page.dart';
import 'package:Pilll/model/auth_user.dart';
import 'package:Pilll/model/setting.dart';
import 'package:Pilll/settings/list/model.dart';
import 'package:Pilll/theme/color.dart';
import 'package:Pilll/theme/font.dart';
import 'package:Pilll/theme/text_color.dart';
import 'package:Pilll/util/formatter/date_time_formatter.dart';
import 'package:Pilll/util/shared_preference/toolbar/date_time_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Pilll/model/pill_sheet_type.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    var setting = context.watch<AuthUser>().user.setting;
    return ChangeNotifierProvider.value(
      value: setting,
      child: Consumer(
          builder: (BuildContext context, Setting setting, Widget child) {
        return ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return _section(
              setting,
              SettingSection.values[index],
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return _separatorItem();
          },
          itemCount: SettingSection.values.length,
          addRepaintBoundaries: false,
        );
      }),
    );
  }

  Widget _sectionTitle(SettingSection section) {
    String text;
    switch (section) {
      case SettingSection.pill:
        text = "ピルの設定";
        break;
      case SettingSection.menstruation:
        text = "生理";
        break;
      case SettingSection.notification:
        text = "通知";
        break;
      case SettingSection.other:
        text = "その他";
        break;
    }
    return ListTile(
        title:
            Text(text, style: FontType.assisting.merge(TextColorStyle.gray)));
  }

  List<SettingListRowModel> _rowModels(
    Setting setting,
    SettingSection section,
  ) {
    switch (section) {
      case SettingSection.pill:
        return [
          SettingListTitleAndContentRowModel(
            title: "種類",
            content: setting.pillSheetType.name,
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return PillSheetTypeSelectPage(
                  title: "種類",
                  callback: (type) {
                    Navigator.pop(context);
                    setting
                        .notifyWith((setting) => setting.pillSheetType = type)
                        .then((setting) => setting.save());
                  },
                  selectedPillSheetType: setting.pillSheetType,
                );
              }));
            },
          ),
        ];
      case SettingSection.menstruation:
        return [
          SettingListTitleRowModel(
              title: "生理について",
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) {
                    return SettingMenstruationPage(
                      title: "生理について",
                      selectedFromMenstruation: setting.fromMenstruation,
                      fromMenstructionDidDecide: (selectedFromMenstruction) {
                        setState(() {
                          setting
                              .notifyWith((setting) => setting
                                  .fromMenstruation = selectedFromMenstruction)
                              .then((setting) => setting.save());
                          Navigator.pop(context);
                        });
                      },
                      selectedDurationMenstruation:
                          setting.durationMenstruation,
                      durationMenstructionDidDecide:
                          (selectedDurationMenstruation) {
                        setState(() {
                          setting
                              .notifyWith((setting) =>
                                  setting.durationMenstruation =
                                      selectedDurationMenstruation)
                              .then((setting) => setting.save());
                          Navigator.pop(context);
                        });
                      },
                    );
                  },
                ));
              }),
        ];
      case SettingSection.notification:
        return [
          SettingsListSwitchRowModel(
            title: "ピルの服用通知",
            value: setting.isOnReminder,
            onTap: () {
              setState(
                () => setting
                    .notifyWith((setting) =>
                        setting.isOnReminder = !setting.isOnReminder)
                    .then((setting) => setting.save()),
              );
            },
          ),
          SettingsListDatePickerRowModel(
            title: "通知時刻",
            content: DateTimeFormatter.string(setting.reminderDateTime()),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return DateTimePicker(
                    initialDateTime: setting.reminderDateTime(),
                    done: (dateTime) {
                      setting.notifyWith(
                        (setting) {
                          setting.reminderHour = dateTime.hour;
                          setting.reminderMinute = dateTime.minute;
                        },
                      ).then((value) => value.save());
                      Navigator.pop(context);
                    },
                  );
                },
              );
            },
          ),
        ];
      case SettingSection.other:
        return [
          SettingListTitleRowModel(
            title: "利用規約",
            onTap: () {
              ChromeSafariBrowser browser =
                  ChromeSafariBrowser(bFallback: null);
              browser.open(url: "https://bannzai.github.io/Pilll/Terms");
            },
          ),
          SettingListTitleRowModel(title: "プライバシーポリシー"),
          SettingListTitleRowModel(title: "お問い合わせ"),
        ];
    }
  }

  Widget _section(Setting setting, SettingSection section) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(section),
        ..._rowModels(setting, section).map((e) => e.widget()),
      ],
    );
  }

  Widget _separatorItem() {
    return Container(
      height: 1,
      color: PilllColors.border,
    );
  }
}
