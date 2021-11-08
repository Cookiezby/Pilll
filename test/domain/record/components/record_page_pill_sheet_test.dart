import 'package:mockito/mockito.dart';
import 'package:pilll/domain/record/components/pill_sheet/components/pill_number.dart';
import 'package:pilll/domain/record/components/pill_sheet/record_page_pill_sheet.dart';
import 'package:pilll/domain/record/record_page_state.dart';
import 'package:pilll/entity/pill_sheet.dart';
import 'package:pilll/entity/pill_sheet_group.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pilll/entity/setting.dart';
import 'package:pilll/service/day.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helper/mock.mocks.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });
  group("#RecordPagePillSheet.textOfPillNumber", () {
    group("pillSheetAppearanceMode is number", () {
      final pillSheetAppearanceMode = PillSheetAppearanceMode.number;
      test("it is isPremium or isTrial", () {
        final originalTodayRepository = todayRepository;
        final mockTodayRepository = MockTodayService();
        final today = DateTime.parse("2020-09-01");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(today);
        when(mockTodayRepository.today()).thenReturn(today);
        addTearDown(() {
          todayRepository = originalTodayRepository;
        });

        final pillNumberForFromMenstruation = 22;
        final durationMenstruation = 4;
        final setting = Setting(
          pillNumberForFromMenstruation: pillNumberForFromMenstruation,
          durationMenstruation: durationMenstruation,
          isOnReminder: true,
          pillSheetAppearanceMode: pillSheetAppearanceMode,
        );
        final state = RecordPageState(
          isPremium: true,
          isTrial: true,
          setting: setting,
        );
        final pillSheet = PillSheet(
            typeInfo: PillSheetType.pillsheet_21.typeInfo, beginingDate: today);
        final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["pill_sheet_id"],
            pillSheets: [pillSheet],
            createdAt: today);
        for (int i = 0; i < 28; i++) {
          final pillNumberIntoPillSheet = i + 1;
          final widget = RecordPagePillSheet.textOfPillNumber(
              state: state,
              pillSheetGroup: pillSheetGroup,
              pillSheet: pillSheet,
              pillNumberIntoPillSheet: pillNumberIntoPillSheet,
              pageIndex: 0,
              setting: setting);

          if (pillNumberIntoPillSheet < pillNumberForFromMenstruation) {
            expect(widget, isA<PlainPillNumber>(),
                reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          } else if (pillNumberIntoPillSheet <
              pillNumberForFromMenstruation + durationMenstruation) {
            expect(widget, isA<MenstruationPillNumber>(),
                reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          } else {
            expect(widget, isA<PlainPillNumber>(),
                reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          }
        }
      });
      test("it is not isPremium and isTrial", () {
        final originalTodayRepository = todayRepository;
        final mockTodayRepository = MockTodayService();
        final today = DateTime.parse("2020-09-01");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(today);
        when(mockTodayRepository.today()).thenReturn(today);
        addTearDown(() {
          todayRepository = originalTodayRepository;
        });

        final pillNumberForFromMenstruation = 22;
        final durationMenstruation = 4;
        final setting = Setting(
          pillNumberForFromMenstruation: pillNumberForFromMenstruation,
          durationMenstruation: durationMenstruation,
          isOnReminder: true,
          pillSheetAppearanceMode: pillSheetAppearanceMode,
        );
        final state = RecordPageState(
          isPremium: true,
          isTrial: true,
          setting: setting,
        );
        final pillSheet = PillSheet(
            typeInfo: PillSheetType.pillsheet_21.typeInfo, beginingDate: today);
        final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["pill_sheet_id"],
            pillSheets: [pillSheet],
            createdAt: today);

        for (int i = 0; i < 28; i++) {
          final pillNumberIntoPillSheet = i + 1;
          final widget = RecordPagePillSheet.textOfPillNumber(
              state: state,
              pillSheetGroup: pillSheetGroup,
              pillSheet: pillSheet,
              pillNumberIntoPillSheet: pillNumberIntoPillSheet,
              pageIndex: 0,
              setting: setting);

          if (pillNumberIntoPillSheet < pillNumberForFromMenstruation) {
            expect(widget, isA<PlainPillNumber>(),
                reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          } else if (pillNumberIntoPillSheet <
              pillNumberForFromMenstruation + durationMenstruation) {
            expect(widget, isA<PlainPillNumber>(),
                reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          } else {
            expect(widget, isA<PlainPillNumber>(),
                reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          }
        }
      });
      test(
          "setting.pillNumberForFromMenstruation == 0 || setting.durationMenstruation == 0",
          () {
        final originalTodayRepository = todayRepository;
        final mockTodayRepository = MockTodayService();
        final today = DateTime.parse("2020-09-01");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(today);
        when(mockTodayRepository.today()).thenReturn(today);
        addTearDown(() {
          todayRepository = originalTodayRepository;
        });

        final pillNumberForFromMenstruation = 0;
        final durationMenstruation = 0;
        final setting = Setting(
          pillNumberForFromMenstruation: pillNumberForFromMenstruation,
          durationMenstruation: durationMenstruation,
          isOnReminder: true,
          pillSheetAppearanceMode: pillSheetAppearanceMode,
        );
        final state = RecordPageState(
          isPremium: true,
          isTrial: true,
          setting: setting,
        );
        final pillSheet = PillSheet(
            typeInfo: PillSheetType.pillsheet_21.typeInfo, beginingDate: today);
        final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["pill_sheet_id"],
            pillSheets: [pillSheet],
            createdAt: today);

        for (int i = 0; i < 28; i++) {
          final pillNumberIntoPillSheet = i + 1;
          final widget = RecordPagePillSheet.textOfPillNumber(
              state: state,
              pillSheetGroup: pillSheetGroup,
              pillSheet: pillSheet,
              pillNumberIntoPillSheet: pillNumberIntoPillSheet,
              pageIndex: 0,
              setting: setting);

          if (pillNumberIntoPillSheet < pillNumberForFromMenstruation) {
            expect(widget, isA<PlainPillNumber>(),
                reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          } else if (pillNumberIntoPillSheet <
              pillNumberForFromMenstruation + durationMenstruation) {
            expect(widget, isA<PlainPillNumber>(),
                reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          } else {
            expect(widget, isA<PlainPillNumber>(),
                reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          }
        }
      });
    });
    group("pillSheetAppearanceMode is date", () {
      final pillSheetAppearanceMode = PillSheetAppearanceMode.date;
      test("it is isPremium or isTrial", () {
        final originalTodayRepository = todayRepository;
        final mockTodayRepository = MockTodayService();
        final today = DateTime.parse("2020-09-01");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(today);
        when(mockTodayRepository.today()).thenReturn(today);
        addTearDown(() {
          todayRepository = originalTodayRepository;
        });

        final pillNumberForFromMenstruation = 22;
        final durationMenstruation = 4;
        final setting = Setting(
          pillNumberForFromMenstruation: pillNumberForFromMenstruation,
          durationMenstruation: durationMenstruation,
          isOnReminder: true,
          pillSheetAppearanceMode: pillSheetAppearanceMode,
        );
        final state = RecordPageState(
          isPremium: true,
          isTrial: true,
          setting: setting,
        );
        final pillSheet = PillSheet(
            typeInfo: PillSheetType.pillsheet_21.typeInfo, beginingDate: today);
        final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["pill_sheet_id"],
            pillSheets: [pillSheet],
            createdAt: today);

        for (int i = 0; i < 28; i++) {
          final pillNumberIntoPillSheet = i + 1;
          final widget = RecordPagePillSheet.textOfPillNumber(
              state: state,
              pillSheetGroup: pillSheetGroup,
              pillSheet: pillSheet,
              pillNumberIntoPillSheet: pillNumberIntoPillSheet,
              pageIndex: 0,
              setting: setting);

          if (pillNumberIntoPillSheet < pillNumberForFromMenstruation) {
            expect(widget, isA<PlainPillDate>(),
                reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          } else if (pillNumberIntoPillSheet <
              pillNumberForFromMenstruation + durationMenstruation) {
            expect(widget, isA<MenstruationPillDate>(),
                reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          } else {
            expect(widget, isA<PlainPillDate>(),
                reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          }
        }
      });
      test(
          "it is not isPremium and isTrial. it is means expired trial or premium user",
          () {
        final originalTodayRepository = todayRepository;
        final mockTodayRepository = MockTodayService();
        final today = DateTime.parse("2020-09-01");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(today);
        when(mockTodayRepository.today()).thenReturn(today);
        addTearDown(() {
          todayRepository = originalTodayRepository;
        });

        final pillNumberForFromMenstruation = 22;
        final durationMenstruation = 4;
        final setting = Setting(
          pillNumberForFromMenstruation: pillNumberForFromMenstruation,
          durationMenstruation: durationMenstruation,
          isOnReminder: true,
          pillSheetAppearanceMode: pillSheetAppearanceMode,
        );
        final state = RecordPageState(
          isPremium: true,
          isTrial: true,
          setting: setting,
        );
        final pillSheet = PillSheet(
            typeInfo: PillSheetType.pillsheet_21.typeInfo, beginingDate: today);
        final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["pill_sheet_id"],
            pillSheets: [pillSheet],
            createdAt: today);

        for (int i = 0; i < 28; i++) {
          final pillNumberIntoPillSheet = i + 1;
          final widget = RecordPagePillSheet.textOfPillNumber(
              state: state,
              pillSheetGroup: pillSheetGroup,
              pillSheet: pillSheet,
              pillNumberIntoPillSheet: pillNumberIntoPillSheet,
              pageIndex: 0,
              setting: setting);

          if (pillNumberIntoPillSheet < pillNumberForFromMenstruation) {
            expect(widget, isA<PlainPillNumber>(),
                reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          } else if (pillNumberIntoPillSheet <
              pillNumberForFromMenstruation + durationMenstruation) {
            expect(widget, isA<PlainPillNumber>(),
                reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          } else {
            expect(widget, isA<PlainPillNumber>(),
                reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          }
        }
      });
      test(
          "isPremium == true && (setting.pillNumberForFromMenstruation == 0 || setting.durationMenstruation == 0)",
          () {
        final originalTodayRepository = todayRepository;
        final mockTodayRepository = MockTodayService();
        final today = DateTime.parse("2020-09-01");
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(today);
        when(mockTodayRepository.today()).thenReturn(today);
        addTearDown(() {
          todayRepository = originalTodayRepository;
        });

        final pillNumberForFromMenstruation = 22;
        final durationMenstruation = 4;
        final setting = Setting(
          pillNumberForFromMenstruation: pillNumberForFromMenstruation,
          durationMenstruation: durationMenstruation,
          isOnReminder: true,
          pillSheetAppearanceMode: pillSheetAppearanceMode,
        );
        final state = RecordPageState(
          isPremium: true,
          isTrial: true,
          setting: setting,
        );
        final pillSheet = PillSheet(
            typeInfo: PillSheetType.pillsheet_21.typeInfo, beginingDate: today);
        final pillSheetGroup = PillSheetGroup(
            pillSheetIDs: ["pill_sheet_id"],
            pillSheets: [pillSheet],
            createdAt: today);

        for (int i = 0; i < 28; i++) {
          final pillNumberIntoPillSheet = i + 1;
          final widget = RecordPagePillSheet.textOfPillNumber(
              state: state,
              pillSheetGroup: pillSheetGroup,
              pillSheet: pillSheet,
              pillNumberIntoPillSheet: pillNumberIntoPillSheet,
              pageIndex: 0,
              setting: setting);

          if (pillNumberIntoPillSheet < pillNumberForFromMenstruation) {
            expect(widget, isA<PlainPillDate>(),
                reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          } else if (pillNumberIntoPillSheet <
              pillNumberForFromMenstruation + durationMenstruation) {
            expect(widget, isA<PlainPillDate>(),
                reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          } else {
            expect(widget, isA<PlainPillDate>(),
                reason: "pillNumberIntoPillSheet: $pillNumberIntoPillSheet");
          }
        }
      });
    });
  });
  group("#RecordPagePillSheet.calculatedDateOfAppearancePill", () {
    test("it is not have rest duration", () {
      final originalTodayRepository = todayRepository;
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-01"));
      when(mockTodayRepository.today())
          .thenReturn(DateTime.parse("2020-09-01"));
      addTearDown(() {
        todayRepository = originalTodayRepository;
      });

      final PillSheet pillSheet = PillSheet(
          typeInfo: PillSheetType.pillsheet_21_0.typeInfo,
          beginingDate: DateTime.parse("2020-09-01"));

      expect(RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 1),
          DateTime.parse("2020-09-01"));
      expect(RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 2),
          DateTime.parse("2020-09-02"));
      expect(RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 3),
          DateTime.parse("2020-09-03"));

      expect(RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 10),
          DateTime.parse("2020-09-10"));
      expect(RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 11),
          DateTime.parse("2020-09-11"));
      expect(RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 12),
          DateTime.parse("2020-09-12"));

      expect(RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 26),
          DateTime.parse("2020-09-26"));
      expect(RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 27),
          DateTime.parse("2020-09-27"));
      expect(RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 28),
          DateTime.parse("2020-09-28"));
    });
    group("it is have rest duration", () {
      group("it is not ended rest duration", () {
        test(
            "simualte begin rest duration. pillSheet.lastTakenDate is yesterday and restDuration.beginDate is today.",
            () {
          final originalTodayRepository = todayRepository;
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now())
              .thenReturn(DateTime.parse("2020-09-11"));
          when(mockTodayRepository.today())
              .thenReturn(DateTime.parse("2020-09-11"));
          addTearDown(() {
            todayRepository = originalTodayRepository;
          });

          final PillSheet pillSheet = PillSheet(
            typeInfo: PillSheetType.pillsheet_21_0.typeInfo,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-10"),
            restDurations: [
              RestDuration(
                beginDate: DateTime.parse("2020-09-11"),
                createdDate: DateTime.parse("2020-09-11"),
              ),
            ],
          );

          expect(
              RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 1),
              DateTime.parse("2020-09-01"));
          expect(
              RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 2),
              DateTime.parse("2020-09-02"));
          expect(
              RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 3),
              DateTime.parse("2020-09-03"));

          expect(
              RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 10),
              DateTime.parse("2020-09-10"));
          expect(
              RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 11),
              DateTime.parse("2020-09-11"));
          expect(
              RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 12),
              DateTime.parse("2020-09-12"));

          expect(
              RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 26),
              DateTime.parse("2020-09-26"));
          expect(
              RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 27),
              DateTime.parse("2020-09-27"));
          expect(
              RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 28),
              DateTime.parse("2020-09-28"));
        });
        test(
            "pillSheet.lastTakenDate is two days ago and restDuration.beginDate from yesterday",
            () {
          final originalTodayRepository = todayRepository;
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now())
              .thenReturn(DateTime.parse("2020-09-12"));
          when(mockTodayRepository.today())
              .thenReturn(DateTime.parse("2020-09-12"));
          addTearDown(() {
            todayRepository = originalTodayRepository;
          });

          final PillSheet pillSheet = PillSheet(
            typeInfo: PillSheetType.pillsheet_21_0.typeInfo,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-10"),
            restDurations: [
              RestDuration(
                beginDate: DateTime.parse("2020-09-11"),
                createdDate: DateTime.parse("2020-09-11"),
              ),
            ],
          );

          expect(
              RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 1),
              DateTime.parse("2020-09-01"));
          expect(
              RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 2),
              DateTime.parse("2020-09-02"));
          expect(
              RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 3),
              DateTime.parse("2020-09-03"));

          expect(
              RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 10),
              DateTime.parse("2020-09-10"));
          expect(
              RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 11),
              DateTime.parse("2020-09-12"));
          expect(
              RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 12),
              DateTime.parse("2020-09-13"));

          expect(
              RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 26),
              DateTime.parse("2020-09-27"));
          expect(
              RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 27),
              DateTime.parse("2020-09-28"));
          expect(
              RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 28),
              DateTime.parse("2020-09-29"));
        });
      });
      group("it is ended rest duration", () {
        test(
            "pillSheet.lastTakenDate is yesterday and restDuration.endDate is today",
            () {
          final originalTodayRepository = todayRepository;
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now())
              .thenReturn(DateTime.parse("2020-09-11"));
          when(mockTodayRepository.today())
              .thenReturn(DateTime.parse("2020-09-11"));
          addTearDown(() {
            todayRepository = originalTodayRepository;
          });

          final PillSheet pillSheet = PillSheet(
            typeInfo: PillSheetType.pillsheet_21_0.typeInfo,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-10"),
            restDurations: [
              RestDuration(
                beginDate: DateTime.parse("2020-09-11"),
                createdDate: DateTime.parse("2020-09-11"),
                endDate: DateTime.parse("2020-09-11"),
              ),
            ],
          );

          expect(
              RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 1),
              DateTime.parse("2020-09-01"));
          expect(
              RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 2),
              DateTime.parse("2020-09-02"));
          expect(
              RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 3),
              DateTime.parse("2020-09-03"));

          expect(
              RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 10),
              DateTime.parse("2020-09-10"));
          expect(
              RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 11),
              DateTime.parse("2020-09-11"));
          expect(
              RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 12),
              DateTime.parse("2020-09-12"));

          expect(
              RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 26),
              DateTime.parse("2020-09-26"));
          expect(
              RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 27),
              DateTime.parse("2020-09-27"));
          expect(
              RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 28),
              DateTime.parse("2020-09-28"));
        });

        test(
            "pillSheet.lastTakenDate is two days ago and restDuration.endDate is today",
            () {
          final originalTodayRepository = todayRepository;
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now())
              .thenReturn(DateTime.parse("2020-09-12"));
          when(mockTodayRepository.today())
              .thenReturn(DateTime.parse("2020-09-12"));
          addTearDown(() {
            todayRepository = originalTodayRepository;
          });

          final PillSheet pillSheet = PillSheet(
            typeInfo: PillSheetType.pillsheet_21_0.typeInfo,
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-10"),
            restDurations: [
              RestDuration(
                beginDate: DateTime.parse("2020-09-11"),
                createdDate: DateTime.parse("2020-09-11"),
                endDate: DateTime.parse("2020-09-12"),
              ),
            ],
          );

          expect(
              RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 1),
              DateTime.parse("2020-09-01"));
          expect(
              RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 2),
              DateTime.parse("2020-09-02"));
          expect(
              RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 3),
              DateTime.parse("2020-09-03"));

          expect(
              RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 10),
              DateTime.parse("2020-09-10"));
          expect(
              RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 11),
              DateTime.parse("2020-09-12"));
          expect(
              RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 12),
              DateTime.parse("2020-09-13"));

          expect(
              RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 26),
              DateTime.parse("2020-09-27"));
          expect(
              RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 27),
              DateTime.parse("2020-09-28"));
          expect(
              RecordPagePillSheet.calculatedDateOfAppearancePill(pillSheet, 28),
              DateTime.parse("2020-09-29"));
        });
      });
    });
  });
  group("#RecordPagePillSheet.isContainedMenstruationDuration", () {
    test("group has only one pill sheet", () async {
      final anyDate = DateTime.parse("2020-09-19");
      final pillSheet = PillSheet(
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: anyDate,
        groupIndex: 0,
      );
      final pillSheetGroup = PillSheetGroup(
        pillSheetIDs: ["1"],
        pillSheets: [pillSheet],
        createdAt: anyDate,
      );
      final setting = Setting(
        pillSheetTypes: [PillSheetType.pillsheet_28_0],
        pillNumberForFromMenstruation: 22,
        durationMenstruation: 3,
        isOnReminder: true,
      );
      final pageIndex = 0;

      for (int i = 1; i <= 28; i++) {
        expect(
            RecordPagePillSheet.isContainedMenstruationDuration(
                pillNumberIntoPillSheet: i,
                pillSheetGroup: pillSheetGroup,
                pageIndex: pageIndex,
                setting: setting),
            22 <= i && i <= 24,
            reason: "print debug informations pillNumberIntoPillSheet is $i");
      }
    });
    test(
        "group has three pill sheet and scheduled menstruation begin No.2 pillSheet",
        () async {
      final anyDate = DateTime.parse("2020-09-19");
      final one = PillSheet(
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: anyDate,
        groupIndex: 0,
      );
      final two = PillSheet(
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: anyDate,
        groupIndex: 1,
      );
      final three = PillSheet(
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: anyDate,
        groupIndex: 2,
      );
      final pillSheetGroup = PillSheetGroup(
        pillSheetIDs: ["1", "2", "3"],
        pillSheets: [one, two, three],
        createdAt: anyDate,
      );
      final setting = Setting(
        pillSheetTypes: [
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0
        ],
        pillNumberForFromMenstruation: 46,
        durationMenstruation: 3,
        isOnReminder: true,
      );
      final pillSheetTypes = [
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0
      ];

      for (int pageIndex = 0; pageIndex < pillSheetTypes.length; pageIndex++) {
        for (int pillNumberIntoPillSheet = 1;
            pillNumberIntoPillSheet <= pillSheetTypes[pageIndex].totalCount;
            pillNumberIntoPillSheet++) {
          expect(
              RecordPagePillSheet.isContainedMenstruationDuration(
                pillNumberIntoPillSheet: pillNumberIntoPillSheet,
                pillSheetGroup: pillSheetGroup,
                pageIndex: pageIndex,
                setting: setting,
              ),
              (pageIndex == 1 &&
                  18 <= pillNumberIntoPillSheet &&
                  pillNumberIntoPillSheet <= 20),
              reason:
                  "print debug informations pillNumberIntoPillSheet is $pillNumberIntoPillSheet, pageIndex: $pageIndex");
        }
      }
    });
    test(
        "group has three pill sheet and scheduled menstruation have all sheets",
        () async {
      final anyDate = DateTime.parse("2020-09-19");
      final one = PillSheet(
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: anyDate,
        groupIndex: 0,
      );
      final two = PillSheet(
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: anyDate,
        groupIndex: 1,
      );
      final three = PillSheet(
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: anyDate,
        groupIndex: 2,
      );
      final pillSheetGroup = PillSheetGroup(
        pillSheetIDs: ["1", "2", "3"],
        pillSheets: [one, two, three],
        createdAt: anyDate,
      );
      final setting = Setting(
        pillSheetTypes: [
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0
        ],
        pillNumberForFromMenstruation: 22,
        durationMenstruation: 3,
        isOnReminder: true,
      );
      final pillSheetTypes = [
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0
      ];

      for (int pageIndex = 0; pageIndex < pillSheetTypes.length; pageIndex++) {
        for (int pillNumberIntoPillSheet = 1;
            pillNumberIntoPillSheet <= pillSheetTypes[pageIndex].totalCount;
            pillNumberIntoPillSheet++) {
          expect(
              RecordPagePillSheet.isContainedMenstruationDuration(
                pillNumberIntoPillSheet: pillNumberIntoPillSheet,
                pillSheetGroup: pillSheetGroup,
                pageIndex: pageIndex,
                setting: setting,
              ),
              22 <= pillNumberIntoPillSheet && pillNumberIntoPillSheet <= 24,
              reason:
                  "print debug informations pillNumberIntoPillSheet is $pillNumberIntoPillSheet, pageIndex: $pageIndex");
        }
      }
    });
    // 仕様的にはこの内容になるけど、ユーザーの入力としては想定されていない。なので仕様がおかしいとなったらこのテストは守らなくて良い
    test(
        "group has five pill sheet and scheduled menstruation begin No.2 pillSheet",
        () async {
      final anyDate = DateTime.parse("2020-09-19");
      final one = PillSheet(
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: anyDate,
        groupIndex: 0,
      );
      final two = PillSheet(
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: anyDate,
        groupIndex: 1,
      );
      final three = PillSheet(
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: anyDate,
        groupIndex: 2,
      );
      final four = PillSheet(
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: anyDate,
        groupIndex: 3,
      );
      final five = PillSheet(
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: anyDate,
        groupIndex: 4,
      );
      final pillSheetGroup = PillSheetGroup(
        pillSheetIDs: ["1", "2", "3", "4", "5"],
        pillSheets: [one, two, three, four, five],
        createdAt: anyDate,
      );
      final setting = Setting(
        pillSheetTypes: [
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0
        ],
        pillNumberForFromMenstruation: 46,
        durationMenstruation: 3,
        isOnReminder: true,
      );

      final pillSheetTypes = [
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0,
      ];

      for (int pageIndex = 0; pageIndex < pillSheetTypes.length; pageIndex++) {
        for (int pillNumberIntoPillSheet = 1;
            pillNumberIntoPillSheet <= pillSheetTypes[pageIndex].totalCount;
            pillNumberIntoPillSheet++) {
          final firstMatched = pageIndex == 1 &&
              18 <= pillNumberIntoPillSheet &&
              pillNumberIntoPillSheet <= 20;
          final secondMatched = pageIndex == 3 &&
              8 <= pillNumberIntoPillSheet &&
              pillNumberIntoPillSheet <= 10;
          final thirdPatched = pageIndex == 4 &&
              26 <= pillNumberIntoPillSheet &&
              pillNumberIntoPillSheet <= 28;
          expect(
              RecordPagePillSheet.isContainedMenstruationDuration(
                pillNumberIntoPillSheet: pillNumberIntoPillSheet,
                pillSheetGroup: pillSheetGroup,
                pageIndex: pageIndex,
                setting: setting,
              ),
              firstMatched || secondMatched || thirdPatched,
              reason:
                  "print debug informations pillNumberIntoPillSheet is $pillNumberIntoPillSheet, pageIndex: $pageIndex");
        }
      }
    });
    test("for ヤーズフレックス", () async {
      final anyDate = DateTime.parse("2020-09-19");
      final one = PillSheet(
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: anyDate,
        groupIndex: 0,
      );
      final two = PillSheet(
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: anyDate,
        groupIndex: 1,
      );
      final three = PillSheet(
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: anyDate,
        groupIndex: 2,
      );
      final four = PillSheet(
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: anyDate,
        groupIndex: 3,
      );
      final five = PillSheet(
        typeInfo: PillSheetType.pillsheet_28_0.typeInfo,
        beginingDate: anyDate,
        groupIndex: 4,
      );
      final pillSheetGroup = PillSheetGroup(
        pillSheetIDs: ["1", "2", "3", "4", "5"],
        pillSheets: [one, two, three, four, five],
        createdAt: anyDate,
      );
      final setting = Setting(
        pillSheetTypes: [
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0,
          PillSheetType.pillsheet_28_0
        ],
        pillNumberForFromMenstruation: 120,
        durationMenstruation: 3,
        isOnReminder: true,
      );

      final pillSheetTypes = [
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0,
        PillSheetType.pillsheet_28_0,
      ];

      for (int pageIndex = 0; pageIndex < pillSheetTypes.length; pageIndex++) {
        for (int pillNumberIntoPillSheet = 1;
            pillNumberIntoPillSheet <= pillSheetTypes[pageIndex].totalCount;
            pillNumberIntoPillSheet++) {
          expect(
              RecordPagePillSheet.isContainedMenstruationDuration(
                pillNumberIntoPillSheet: pillNumberIntoPillSheet,
                pillSheetGroup: pillSheetGroup,
                pageIndex: pageIndex,
                setting: setting,
              ),
              pageIndex == 4 &&
                  8 <= pillNumberIntoPillSheet &&
                  pillNumberIntoPillSheet <= 10,
              reason:
                  "print debug informations pillNumberIntoPillSheet is $pillNumberIntoPillSheet, pageIndex: $pageIndex");
        }
      }
    });
  });
}
