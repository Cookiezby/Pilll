import 'dart:async';
import 'dart:math';

import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/pill_sheet_modified_history_date_component.dart';
import 'package:pilll/domain/calendar/components/pill_sheet_modified_history/components/pill_sheet_modified_history_taken_pill_action.dart';
import 'package:pilll/domain/pill_sheet_modified_history/pill_sheet_modified_history_state.dart';
import 'package:pilll/entity/pill_sheet_modified_history.dart';
import 'package:pilll/entity/pill_sheet_modified_history_value.dart';
import 'package:pilll/service/pill_sheet_modified_history.dart';
import 'package:riverpod/riverpod.dart';

final pillSheetModifiedHistoryStoreProvider = StateNotifierProvider.autoDispose<
    PillSheetModifiedHistoryStateStore, PillSheetModifiedHistoryState>(
  (ref) => PillSheetModifiedHistoryStateStore(
    ref.watch(pillSheetModifiedHistoryServiceProvider),
  ),
);

class PillSheetModifiedHistoryStateStore
    extends StateNotifier<PillSheetModifiedHistoryState> {
  final PillSheetModifiedHistoryService _pillSheetModifiedHistoryService;
  PillSheetModifiedHistoryStateStore(
    this._pillSheetModifiedHistoryService,
  ) : super(PillSheetModifiedHistoryState()) {
    reset();
  }

  void reset() {
    state = state.copyWith(isLoading: true);
    Future(() async {
      final pillSheetModifiedHistories =
          await _pillSheetModifiedHistoryService.fetchList(null, 20);
      state = state.copyWith(
        pillSheetModifiedHistories: pillSheetModifiedHistories,
        isFirstLoadEnded: true,
        isLoading: false,
      );
      _subscribe();
    });
  }

  StreamSubscription? _pillSheetModifiedHistoryCanceller;
  void _subscribe() {
    _pillSheetModifiedHistoryCanceller?.cancel();
    _pillSheetModifiedHistoryCanceller = _pillSheetModifiedHistoryService
        .stream(max(state.pillSheetModifiedHistories.length, 20))
        .listen((event) {
      state = state.copyWith(pillSheetModifiedHistories: event);
    });
  }

  @override
  void dispose() {
    _pillSheetModifiedHistoryCanceller?.cancel();
    super.dispose();
  }

  Future<void> fetchNext() async {
    if (state.pillSheetModifiedHistories.isEmpty) {
      return Future.value();
    }
    state = state.copyWith(isLoading: true);
    final pillSheetModifiedHistories =
        await _pillSheetModifiedHistoryService.fetchList(
            state.pillSheetModifiedHistories.last.estimatedEventCausingDate,
            20);
    state = state.copyWith(
        pillSheetModifiedHistories:
            state.pillSheetModifiedHistories + pillSheetModifiedHistories,
        isLoading: false);
    _subscribe();
  }

  Future<void> editTakenValue(
    DateTime actualTakenDate,
    PillSheetModifiedHistory history,
    PillSheetModifiedHistoryValue value,
    TakenPillValue takenPillValue,
  ) {
    return updateForEditTakenValue(
      service: _pillSheetModifiedHistoryService,
      actualTakenDate: actualTakenDate,
      history: history,
      value: value,
      takenPillValue: takenPillValue,
    );
  }
}
