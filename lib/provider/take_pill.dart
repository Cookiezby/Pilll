import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:pilll/entity/pill.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/provider/batch.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/utils/emoji/emoji.dart';
import 'package:pilll/utils/error_log.dart';

import 'package:pilll/provider/pill_sheet_group.dart';
import 'package:pilll/provider/pill_sheet_modified_history.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:riverpod/riverpod.dart';

final takePillProvider = Provider(
  (ref) => TakePill(
    batchFactory: ref.watch(batchFactoryProvider),
    batchSetPillSheetModifiedHistory: ref.watch(batchSetPillSheetModifiedHistoryProvider),
    batchSetPillSheetGroup: ref.watch(batchSetPillSheetGroupProvider),
  ),
);

class TakePill {
  final BatchFactory batchFactory;

  final BatchSetPillSheetModifiedHistory batchSetPillSheetModifiedHistory;
  final BatchSetPillSheetGroup batchSetPillSheetGroup;

  TakePill({
    required this.batchFactory,
    required this.batchSetPillSheetModifiedHistory,
    required this.batchSetPillSheetGroup,
  });

  // pageIndexAndPillIndexまでtakenDateで服用済み記録をする
  // pageIndexAndPillIndexがnullの場合はactivePillSheetのtodayPillIndexまで服用済みにする
  // pageIndexAndPillIndexは、1つ前のピルシートのピルを個別にタップした時などに必要になる。それ以外はnullでも良い
  Future<PillSheetGroup?> call({
    required (int, int)? pageIndexAndPillIndex,
    required DateTime takenDate,
    required PillSheetGroup pillSheetGroup,
    required PillSheet activePillSheet,
    required bool isQuickRecord,
  }) async {
    final (pageIndex, pillIndex) = pageIndexAndPillIndex ?? (activePillSheet.groupIndex, activePillSheet.todayPillIndex);

    if (activePillSheet.todayPillsAreAlreadyTaken) {
      return null;
    }

    final updatedPillSheets = pillSheetGroup.pillSheets.map((pillSheet) {
      // activePillSheetが服用可能な最後のピルシートなので、それよりも後ろのピルシートの場合はreturn
      if (pillSheet.groupIndex > activePillSheet.groupIndex) {
        return pillSheet;
      }
      // pageIndex後ろのピルシートの場合はreturn
      if (pillSheet.groupIndex > pageIndex) {
        return pillSheet;
      }
      if (pillSheet.isEnded) {
        return pillSheet;
      }

      // takenDateよりも予測するピルシートの最終服用日よりも小さい場合は、そのピルシートの最終日で予測する最終服用日を記録する
      if (takenDate.isAfter(pillSheet.estimatedEndTakenDate)) {
        return pillSheet.takenPillSheet(
          takenDate: pillSheet.estimatedEndTakenDate,
          pageIndex: pageIndex,
          pillIndex: pillIndex,
        );
      }

      // takenDateがピルシートの開始日に満たない場合は、記録の対象になっていないので早期リターン
      // 一つ前のピルシートのピルをタップした時など
      if (takenDate.date().isBefore(pillSheet.beginingDate.date())) {
        return pillSheet;
      }

      return pillSheet.takenPillSheet(
        takenDate: takenDate,
        pageIndex: pageIndex,
        pillIndex: pillIndex,
      );
    }).toList();

    final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: updatedPillSheets);
    final updatedIndexses = pillSheetGroup.pillSheets.asMap().keys.where((index) {
      final updatedPillSheet = updatedPillSheetGroup.pillSheets[index];
      if (pillSheetGroup.pillSheets[index] == updatedPillSheet) {
        return false;
      }

      return true;
    }).toList();

    if (updatedIndexses.isEmpty) {
      // NOTE: prevent error for unit test
      if (Firebase.apps.isNotEmpty) {
        errorLogger.recordError(const FormatException("unexpected updatedIndexes is empty"), StackTrace.current);
      }
      return null;
    }

    final batch = batchFactory.batch();
    batchSetPillSheetGroup(batch, updatedPillSheetGroup);

    final before = pillSheetGroup.pillSheets[updatedIndexses.first];
    final after = updatedPillSheetGroup.pillSheets[updatedIndexses.last];
    final history = PillSheetModifiedHistoryServiceActionFactory.createTakenPillAction(
      pillSheetGroupID: pillSheetGroup.id,
      before: before,
      after: after,
      isQuickRecord: isQuickRecord,
      beforePillSheetGroup: pillSheetGroup,
      afterPillSheetGroup: updatedPillSheetGroup,
    );
    batchSetPillSheetModifiedHistory(batch, history);

    // 服用記録はBackendの通知等によく使われるので、DBに書き込まれたあとにStreamを通じてUIを更新する
    awaitsPillSheetGroupRemoteDBDataChanged = true;

    await batch.commit();

    return updatedPillSheetGroup;
  }
}

extension TakenPillSheet on PillSheet {
  PillSheet takenPillSheet({
    required DateTime takenDate,
    required int pageIndex,
    required int pillIndex,
  }) {
    return copyWith(
      lastTakenDate: takenDate,
      pills: pills.map((pill) {
        if (pill.index > todayPillIndex) {
          return pill;
        }
        if (pill.index > pageIndex) {
          return pill;
        }
        if (pill.pillTakens.length == pillTakenCount) {
          return pill;
        }
        final pillTakenDoneList = [...pill.pillTakens];

        if (pill.index != todayPillIndex) {
          // NOTE: 今日以外のピルは、今日のピルを飲んだ時点で、今日のピルの服用記録を追加する
          for (var i = max(0, pill.pillTakens.length - 1); i < pillTakenCount; i++) {
            pillTakenDoneList.add(PillTaken(
              takenDateTime: takenDate,
              createdDateTime: now(),
              updatedDateTime: now(),
            ));
          }
        } else {
          // pill == todayPillIndex
          // NOTE: 今日のピルは、今日のピルを飲んだ時点で、今日のピルの服用記録を追加する
          pillTakenDoneList.add(PillTaken(
            takenDateTime: takenDate,
            createdDateTime: now(),
            updatedDateTime: now(),
          ));
        }
        return pill.copyWith(pillTakens: pillTakenDoneList);
      }).toList(),
    );
  }
}
