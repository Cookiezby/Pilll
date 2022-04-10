import 'package:pilll/components/molecules/indicator.dart';
import 'package:pilll/domain/initial_setting/migrate_info.dart';
import 'package:pilll/domain/premium_function_survey/premium_function_survey_page.dart';
import 'package:pilll/domain/premium_trial/premium_trial_complete_modal.dart';
import 'package:pilll/domain/record/components/add/add_pill_sheet_group_empty_frame.dart';
import 'package:pilll/domain/record/components/button/record_page_button.dart';
import 'package:pilll/domain/record/components/notification_bar/notification_bar.dart';
import 'package:pilll/domain/record/components/supports/record_page_pill_sheet_support_actions.dart';
import 'package:pilll/domain/record/components/pill_sheet/record_page_pill_sheet_list.dart';
import 'package:pilll/domain/record/record_page_state.codegen.dart';
import 'package:pilll/domain/record/record_page_store.dart';
import 'package:pilll/domain/record/components/header/record_page_header.dart';
import 'package:pilll/domain/premium_trial/premium_trial_modal.dart';
import 'package:pilll/entity/setting.codegen.dart';
import 'package:pilll/error/universal_error_page.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/hooks/automatic_keep_alive_client_mixin.dart';

class RecordPage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recordPageStoreProvider);
    final store = ref.watch(recordPageStoreProvider.notifier);
    useAutomaticKeepAlive(wantKeepAlive: true);

    final exception = state.exception;
    if (exception != null) {
      return UniversalErrorPage(
        error: exception,
        reload: () => store.reset(),
        child: null,
      );
    }

    final pillSheetGroup = state.pillSheetGroup;
    final activedPillSheet = pillSheetGroup?.activedPillSheet;
    final setting = state.setting;
    if (setting == null || !state.firstLoadIsEnded) {
      return const Indicator();
    }

    Future.microtask(() async {
      if (state.shouldShowMigrateInfo) {
        _showMigrateInfoDialog(context, store);
      } else if (state.shouldShowPremiumFunctionSurvey) {
        await store.setTrueIsAlreadyShowPremiumFunctionSurvey();
        Navigator.of(context).push(PremiumFunctionSurveyPageRoutes.route());
      } else if (state.shouldShowTrial) {
        showPremiumTrialModalWhenLaunchApp(context, () {
          showPremiumTrialCompleteModalPreDialog(context);
        });
      }
    });

    return UniversalErrorPage(
      error: state.exception,
      reload: () => store.reset(),
      child: Scaffold(
        backgroundColor: PilllColors.background,
        appBar: AppBar(
          titleSpacing: 0,
          backgroundColor: PilllColors.white,
          toolbarHeight: RecordPageInformationHeaderConst.height,
          title: RecordPageInformationHeader(
            today: DateTime.now(),
            pillSheetGroup: state.pillSheetGroup,
            setting: setting,
            store: store,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  NotificationBar(state),
                  const SizedBox(height: 37),
                  _content(context, setting, state, store),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            if (activedPillSheet != null &&
                pillSheetGroup != null &&
                !pillSheetGroup.isDeactived) ...[
              RecordPageButton(currentPillSheet: activedPillSheet),
              const SizedBox(height: 40),
            ],
          ],
        ),
      ),
    );
  }

  Widget _content(
    BuildContext context,
    Setting setting,
    RecordPageState state,
    RecordPageStore store,
  ) {
    final pillSheetGroup = state.pillSheetGroup;
    final activedPillSheet = pillSheetGroup?.activedPillSheet;
    if (activedPillSheet == null ||
        pillSheetGroup == null ||
        pillSheetGroup.isDeactived)
      return AddPillSheetGroupEmptyFrame(
        context: context,
        store: store,
        setting: setting,
      );
    else
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          RecordPagePillSheetSupportActions(
            store: store,
            pillSheetGroup: pillSheetGroup,
            activedPillSheet: activedPillSheet,
            setting: setting,
          ),
          const SizedBox(height: 16),
          RecordPagePillSheetList(
            state: state,
            store: store,
            setting: setting,
          ),
        ],
      );
  }

  Future<void> _showMigrateInfoDialog(
      BuildContext context, RecordPageStore store) async {
    showDialog(
        context: context,
        barrierColor: Colors.white,
        builder: (context) {
          return MigrateInfo(
            onClose: () async {
              await store.shownMigrateInfo();
              Navigator.of(context).pop();
            },
          );
        });
  }
}
