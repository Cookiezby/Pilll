import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pilll/domain/menstruation_list/menstruation_history_row.dart';
import 'package:pilll/domain/menstruation_list/menstruation_list_state.dart';
import 'package:pilll/service/menstruation.dart';
import 'package:pilll/domain/menstruation/menstruation_store.dart';

final menstruationListStoreProvider = StateNotifierProvider(
  (ref) => MenstruationListStore(
    menstruationService: ref.watch(menstruationServiceProvider),
  ),
);

class MenstruationListStore extends StateNotifier<MenstruationListState> {
  final MenstruationService menstruationService;
  MenstruationListStore({
    required this.menstruationService,
  }) : super(MenstruationListState()) {
    _reset();
  }

  void _reset() {
    Future(() async {
      final menstruations = await menstruationService.fetchAll();
      state = state.copyWith(
        isNotYetLoaded: false,
        allRows: MenstruationHistoryRowState.rows(
            dropLatestMenstruationIfNeeded(menstruations)),
      );
      _subscribe();
    });
  }

  StreamSubscription? _menstruationCanceller;
  void _subscribe() {
    _menstruationCanceller?.cancel();
    _menstruationCanceller =
        menstruationService.subscribeAll().listen((entities) {
      state = state.copyWith(
          allRows: MenstruationHistoryRowState.rows(
              dropLatestMenstruationIfNeeded(entities)));
    });
  }

  @override
  void dispose() {
    _menstruationCanceller?.cancel();
    super.dispose();
  }
}
