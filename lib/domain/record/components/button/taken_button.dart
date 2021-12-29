import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/analytics.dart';
import 'package:pilll/components/atoms/buttons.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/domain/record/util/take.dart';
import 'package:pilll/entity/pill_sheet.dart';

class TakenButton extends HookConsumerWidget {
  final BuildContext parentContext;
  final PillSheet pillSheet;

  const TakenButton({
    Key? key,
    required this.parentContext,
    required this.pillSheet,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final store = useProvider(recordPageStoreProvider);
    return PrimaryButton(
      text: "飲んだ",
      onPressed: () async {
        analytics.logEvent(name: "taken_button_pressed", parameters: {
          "last_taken_pill_number": pillSheet.lastTakenPillNumber,
          "today_pill_number": pillSheet.todayPillNumber,
        });
        await effectAfterTaken(
          context: parentContext,
          taken: store.taken(),
          store: store,
        );
      },
    );
  }
}
