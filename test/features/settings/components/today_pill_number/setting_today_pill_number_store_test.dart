import 'package:pilll/entity/pill.codegen.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_group.codegen.dart';
import 'package:pilll/entity/pill_sheet_modified_history.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pilll/provider/change_pill_number.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../helper/mock.mocks.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });
  group("#modifiyTodayPillNumber", () {
    test("group has only one pill sheet and it is not yet taken", () async {
      var mockTodayRepository = MockTodayService();
      final mockToday = DateTime.parse("2020-09-19");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(mockToday);
      when(mockTodayRepository.now()).thenReturn(mockToday);

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);
      final pillSheet = PillSheet.create(
        PillSheetType.pillsheet_28_0,
        beginDate: mockToday,
        lastTakenDate: null,
      );
      final updatedPillSheet = pillSheet.copyWith(
        beginDate: mockToday.subtract(
          const Duration(days: 1),
        ),
        lastTakenDate: mockToday.subtract(
          const Duration(days: 1),
        ),
      );

      final pillSheetGroup = PillSheetGroup(
        id: "group_id",
        pillSheetIDs: ["sheet_id"],
        pillSheets: [
          pillSheet,
        ],
        createdAt: now(),
      );
      final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [updatedPillSheet]);
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
      when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

      final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
        pillSheetGroupID: "group_id",
        before: pillSheet,
        after: updatedPillSheet,
        beforePillSheetGroup: pillSheetGroup,
        afterPillSheetGroup: updatedPillSheetGroup,
      );

      final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
      when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

      final changePillNumber = ChangePillNumber(
        batchFactory: batchFactory,
        batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
        batchSetPillSheetGroup: batchSetPillSheetGroup,
      );

      expect(pillSheet.todayPillNumber, 1);

      await changePillNumber(
        pillSheetGroup: pillSheetGroup,
        activedPillSheet: pillSheetGroup.activedPillSheet!,
        pillSheetPageIndex: 0,
        pillNumberIntoPillSheet: 2,
      );
    });

    test("group has only one pill sheet and it is already taken", () async {
      var mockTodayRepository = MockTodayService();
      final mockToday = DateTime.parse("2020-09-19");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(mockToday);
      when(mockTodayRepository.now()).thenReturn(mockToday);

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);
      final pillSheet = PillSheet.create(
        PillSheetType.pillsheet_28_0,
        beginDate: mockToday,
        lastTakenDate: mockToday,
      );
      final updatedPillSheet = pillSheet.copyWith(
        beginDate: mockToday.subtract(
          const Duration(days: 1),
        ),
        lastTakenDate: mockToday.subtract(
          const Duration(days: 1),
        ),
      );

      final pillSheetGroup = PillSheetGroup(
        id: "group_id",
        pillSheetIDs: ["sheet_id"],
        pillSheets: [
          pillSheet,
        ],
        createdAt: now(),
      );
      final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [updatedPillSheet]);
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
      when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

      final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
        pillSheetGroupID: "group_id",
        before: pillSheet,
        after: updatedPillSheet,
        beforePillSheetGroup: pillSheetGroup,
        afterPillSheetGroup: updatedPillSheetGroup,
      );

      final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
      when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

      final changePillNumber = ChangePillNumber(
        batchFactory: batchFactory,
        batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
        batchSetPillSheetGroup: batchSetPillSheetGroup,
      );

      expect(pillSheet.todayPillNumber, 1);

      await changePillNumber(
        pillSheetGroup: pillSheetGroup,
        activedPillSheet: pillSheetGroup.activedPillSheet!,
        pillSheetPageIndex: 0,
        pillNumberIntoPillSheet: 2,
      );
    });

    test("group has three pill sheet and it is changed direction middle to left", () async {
      var mockTodayRepository = MockTodayService();
      final mockToday = DateTime.parse("2022-05-01");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(mockToday);
      when(mockTodayRepository.now()).thenReturn(mockToday);

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);
      final left = PillSheet.create(
        PillSheetType.pillsheet_28_0,
        beginDate: DateTime.parse("2022-04-03"),
        lastTakenDate: DateTime.parse("2022-04-30"),
      );
      final middle = PillSheet.create(
        PillSheetType.pillsheet_28_0,
        beginDate: DateTime.parse("2022-05-01"),
        lastTakenDate: null,
      );
      final right = PillSheet.create(
        PillSheetType.pillsheet_28_0,
        beginDate: DateTime.parse("2022-05-29"),
        lastTakenDate: null,
      );
      final updatedLeft = left.copyWith(
        beginDate: DateTime.parse("2022-04-04"),
        lastTakenDate: DateTime.parse("2022-04-30"), // todayPillNumber - 1
      );
      final updatedMiddle = middle.copyWith(
        beginDate: DateTime.parse("2022-05-02"),
      );
      final updatedRight = right.copyWith(
        beginDate: DateTime.parse("2022-05-30"),
      );

      final pillSheetGroup = PillSheetGroup(
        id: "group_id",
        pillSheetIDs: ["sheet_id_left", "sheet_id_middle", "sheet_id_right"],
        pillSheets: [
          left,
          middle,
          right,
        ],
        createdAt: now(),
      );
      final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [
        updatedLeft,
        updatedMiddle,
        updatedRight,
      ]);
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
      when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

      final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
        pillSheetGroupID: "group_id",
        before: middle,
        after: updatedLeft,
        beforePillSheetGroup: pillSheetGroup,
        afterPillSheetGroup: updatedPillSheetGroup,
      );

      final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
      when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

      final changePillNumber = ChangePillNumber(
        batchFactory: batchFactory,
        batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
        batchSetPillSheetGroup: batchSetPillSheetGroup,
      );

      expect(middle.todayPillNumber, 1);

      await changePillNumber(
        pillSheetGroup: pillSheetGroup,
        activedPillSheet: pillSheetGroup.activedPillSheet!,
        pillSheetPageIndex: 0,
        pillNumberIntoPillSheet: 28,
      );
    });
    test("group has three pill sheet and it is changed direction middle to left and cheking clear lastTakenDate", () async {
      var mockTodayRepository = MockTodayService();
      final mockToday = DateTime.parse("2022-05-01");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(mockToday);
      when(mockTodayRepository.now()).thenReturn(mockToday);

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);
      final left = PillSheet.create(
        PillSheetType.pillsheet_28_0,
        beginDate: DateTime.parse("2022-04-03"),
        lastTakenDate: DateTime.parse("2022-04-30"),
      );
      final middle = PillSheet.create(
        PillSheetType.pillsheet_28_0,
        beginDate: DateTime.parse("2022-05-01"),
        lastTakenDate: DateTime.parse("2022-05-01"),
      );
      final right = PillSheet.create(
        PillSheetType.pillsheet_28_0,
        beginDate: DateTime.parse("2022-05-29"),
        lastTakenDate: null,
      );
      final updatedLeft = left.copyWith(
        beginDate: DateTime.parse("2022-04-04"),
        lastTakenDate: DateTime.parse("2022-04-30"), // todayPillNumber - 1
      );
      final updatedMiddle = middle.copyWith(
        beginDate: DateTime.parse("2022-05-02"),
        lastTakenDate: null,
      );
      final updatedRight = right.copyWith(
        beginDate: DateTime.parse("2022-05-30"),
      );

      final pillSheetGroup = PillSheetGroup(
        id: "group_id",
        pillSheetIDs: ["sheet_id_left", "sheet_id_middle", "sheet_id_right"],
        pillSheets: [
          left,
          middle,
          right,
        ],
        createdAt: now(),
      );
      final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [
        updatedLeft,
        updatedMiddle,
        updatedRight,
      ]);
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
      when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

      final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
        pillSheetGroupID: "group_id",
        before: middle,
        after: updatedLeft,
        beforePillSheetGroup: pillSheetGroup,
        afterPillSheetGroup: updatedPillSheetGroup,
      );

      final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
      when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

      final changePillNumber = ChangePillNumber(
        batchFactory: batchFactory,
        batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
        batchSetPillSheetGroup: batchSetPillSheetGroup,
      );

      expect(middle.todayPillNumber, 1);

      await changePillNumber(
        pillSheetGroup: pillSheetGroup,
        activedPillSheet: pillSheetGroup.activedPillSheet!,
        pillSheetPageIndex: 0,
        pillNumberIntoPillSheet: 28,
      );
    });
    test("group has three pill sheet and it is changed direction middle to right", () async {
      var mockTodayRepository = MockTodayService();
      final mockToday = DateTime.parse("2022-05-01");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(mockToday);
      when(mockTodayRepository.now()).thenReturn(mockToday);

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);
      final left = PillSheet.create(
        PillSheetType.pillsheet_28_0,
        beginDate: DateTime.parse("2022-04-03"),
        lastTakenDate: DateTime.parse("2022-04-30"),
      );
      final middle = PillSheet.create(
        PillSheetType.pillsheet_28_0,
        beginDate: DateTime.parse("2022-05-01"),
        lastTakenDate: null,
      );
      final right = PillSheet.create(
        PillSheetType.pillsheet_28_0,
        beginDate: DateTime.parse("2022-05-29"),
        lastTakenDate: null,
      );
      final updatedLeft = left.copyWith(
        beginDate: DateTime.parse("2022-03-06"),
        lastTakenDate: DateTime.parse("2022-04-02"),
      );
      final updatedMiddle = middle.copyWith(
        beginDate: DateTime.parse("2022-04-03"),
        lastTakenDate: DateTime.parse("2022-04-30"),
      );
      final updatedRight = right.copyWith(
        beginDate: DateTime.parse("2022-05-01"),
        lastTakenDate: DateTime.parse("2022-04-30"),
      );

      final pillSheetGroup = PillSheetGroup(
        id: "group_id",
        pillSheetIDs: ["sheet_id_left", "sheet_id_middle", "sheet_id_right"],
        pillSheets: [
          left,
          middle,
          right,
        ],
        createdAt: now(),
      );
      final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [
        updatedLeft,
        updatedMiddle,
        updatedRight,
      ]);
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
      when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

      final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
        pillSheetGroupID: "group_id",
        before: middle,
        after: updatedRight,
        beforePillSheetGroup: pillSheetGroup,
        afterPillSheetGroup: updatedPillSheetGroup,
      );

      final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
      when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

      final changePillNumber = ChangePillNumber(
        batchFactory: batchFactory,
        batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
        batchSetPillSheetGroup: batchSetPillSheetGroup,
      );

      expect(middle.todayPillNumber, 1);

      await changePillNumber(
        pillSheetGroup: pillSheetGroup,
        activedPillSheet: pillSheetGroup.activedPillSheet!,
        pillSheetPageIndex: 2,
        pillNumberIntoPillSheet: 1,
      );
    });
  });
  group("pill sheet has rest durations", () {
    test("group has three pill sheet and it is changed direction middle to left", () async {
      var mockTodayRepository = MockTodayService();
      final mockToday = DateTime.parse("2022-05-02");
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(mockToday);
      when(mockTodayRepository.now()).thenReturn(mockToday);

      final batchFactory = MockBatchFactory();
      final batch = MockWriteBatch();
      when(batchFactory.batch()).thenReturn(batch);
      final left = PillSheet.create(
        PillSheetType.pillsheet_28_0,
        beginDate: DateTime.parse("2022-04-03"),
        lastTakenDate: DateTime.parse("2022-04-30"),
      );
      final middle = PillSheet.create(
        PillSheetType.pillsheet_28_0,
        beginDate: DateTime.parse("2022-05-02"),
        lastTakenDate: null,
      );
      final right = PillSheet.create(
        PillSheetType.pillsheet_28_0,
        beginDate: DateTime.parse("2022-05-29"),
        lastTakenDate: null,
      );
      final updatedLeft = left.copyWith(
        beginDate: DateTime.parse("2022-04-05"),
        lastTakenDate: DateTime.parse("2022-05-01"), // todayPillNumber - 1
        restDurations: [],
      );
      final updatedMiddle = middle.copyWith(
        beginDate: DateTime.parse("2022-05-03"),
      );
      final updatedRight = right.copyWith(
        beginDate: DateTime.parse("2022-05-31"),
      );

      final pillSheetGroup = PillSheetGroup(
        id: "group_id",
        pillSheetIDs: ["sheet_id_left", "sheet_id_middle", "sheet_id_right"],
        pillSheets: [
          left,
          middle,
          right,
        ],
        createdAt: now(),
      );
      final updatedPillSheetGroup = pillSheetGroup.copyWith(pillSheets: [
        updatedLeft,
        updatedMiddle,
        updatedRight,
      ]);
      final batchSetPillSheetGroup = MockBatchSetPillSheetGroup();
      when(batchSetPillSheetGroup(batch, updatedPillSheetGroup)).thenReturn(updatedPillSheetGroup);

      final history = PillSheetModifiedHistoryServiceActionFactory.createChangedPillNumberAction(
        pillSheetGroupID: "group_id",
        before: middle,
        after: updatedLeft,
        beforePillSheetGroup: pillSheetGroup,
        afterPillSheetGroup: updatedPillSheetGroup,
      );

      final batchSetPillSheetModifiedHistory = MockBatchSetPillSheetModifiedHistory();
      when(batchSetPillSheetModifiedHistory(batch, history)).thenReturn(null);

      final changePillNumber = ChangePillNumber(
        batchFactory: batchFactory,
        batchSetPillSheetModifiedHistory: batchSetPillSheetModifiedHistory,
        batchSetPillSheetGroup: batchSetPillSheetGroup,
      );

      expect(middle.todayPillNumber, 1);
      await changePillNumber(
        pillSheetGroup: pillSheetGroup,
        activedPillSheet: pillSheetGroup.activedPillSheet!,
        pillSheetPageIndex: 0,
        pillNumberIntoPillSheet: 28,
      );
    });
  });
}
