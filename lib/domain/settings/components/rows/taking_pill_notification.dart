import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/domain/settings/setting_page_store.dart';
import 'package:pilll/entity/setting.codegen.dart';

class TakingPillNotification extends HookConsumerWidget {
  final Setting setting;

  const TakingPillNotification({
    Key? key,
    required this.setting,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(settingStoreProvider.notifier);
    return SwitchListTile(
      title: const Text("ピルの服用通知", style: FontType.listRow),
      activeColor: PilllColors.primary,
      onChanged: (bool value) {
        analytics.logEvent(
          name: "did_select_toggle_reminder",
        );
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        store.modifyIsOnReminder(!setting.isOnReminder).then((state) {
          final setting = state.setting;
          if (setting == null) {
            return;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 2),
              content: Text(
                "服用通知を${setting.isOnReminder ? "ON" : "OFF"}にしました",
              ),
            ),
          );
        });
      },
      value: setting.isOnReminder,
      // NOTE: when configured subtitle, the space between elements becomes very narrow
      contentPadding: const EdgeInsets.fromLTRB(14, 4, 6, 0),
    );
  }
}
