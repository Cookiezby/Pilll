import 'package:pilll/entity/firestore_id_generator.dart';
import 'package:pilll/entity/pill.codegen.dart';
import 'package:pilll/entity/pill_sheet.codegen.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/utils/datetime/day.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/mock.mocks.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
  });
  group("#todayPillNumber", () {
    test("today: 2020-09-19, begin: 2020-09-14, end: 2020-09-18", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-14"),
        lastTakenDate: DateTime.parse("2020-09-18"),
        createdAt: now(),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
        pills: Pill.testGenerateAndIterateTo(
            pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-14"), lastTakenDate: DateTime.parse("2020-09-18"), pillTakenCount: 1),
      );
      expect(model.todayPillNumber, 6);
    });
    test("today: 2020-09-28, begin: 2020-09-01, end: 2020-09-28", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-01"),
        lastTakenDate: DateTime.parse("2020-09-28"),
        createdAt: now(),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
        pills: Pill.testGenerateAndIterateTo(
            pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-01"), lastTakenDate: DateTime.parse("2020-09-28"), pillTakenCount: 1),
      );
      expect(model.todayPillNumber, 28);
    });
    group("pillsheet has rest durations", () {
      test("rest duration is not end", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          restDurations: [
            RestDuration(
              beginDate: DateTime.parse("2020-09-22"),
              createdDate: DateTime.parse("2020-09-22"),
            )
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          pills: Pill.testGenerateAndIterateTo(
              pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-01"), lastTakenDate: DateTime.parse("2020-09-28"), pillTakenCount: 1),
        );
        expect(model.todayPillNumber, 22);
      });

      test("rest duration is ended", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          restDurations: [
            RestDuration(
              beginDate: DateTime.parse("2020-09-22"),
              createdDate: DateTime.parse("2020-09-22"),
              endDate: DateTime.parse("2020-09-25"),
            )
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          pills: Pill.testGenerateAndIterateTo(
              pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-01"), lastTakenDate: DateTime.parse("2020-09-28"), pillTakenCount: 1),
        );
        expect(model.todayPillNumber, 25);
      });
      group("pill sheet has plural rest duration. ", () {
        test("last rest duration is not ended", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

          const sheetType = PillSheetType.pillsheet_21;
          final model = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-28"),
            createdAt: now(),
            restDurations: [
              RestDuration(
                beginDate: DateTime.parse("2020-09-12"),
                createdDate: DateTime.parse("2020-09-12"),
                endDate: DateTime.parse("2020-09-15"),
              ),
              RestDuration(
                beginDate: DateTime.parse("2020-09-22"),
                createdDate: DateTime.parse("2020-09-22"),
              )
            ],
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
            pills: Pill.testGenerateAndIterateTo(
                pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-01"), lastTakenDate: DateTime.parse("2020-09-28"), pillTakenCount: 1),
          );
          expect(model.todayPillNumber, 19);
        });
        test("last rest duration is ended", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

          const sheetType = PillSheetType.pillsheet_21;
          final model = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-28"),
            createdAt: now(),
            restDurations: [
              RestDuration(
                beginDate: DateTime.parse("2020-09-12"),
                createdDate: DateTime.parse("2020-09-12"),
                endDate: DateTime.parse("2020-09-15"),
              ),
              RestDuration(
                beginDate: DateTime.parse("2020-09-22"),
                createdDate: DateTime.parse("2020-09-22"),
                endDate: DateTime.parse("2020-09-25"),
              )
            ],
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
            pills: Pill.testGenerateAndIterateTo(
                pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-01"), lastTakenDate: DateTime.parse("2020-09-28"), pillTakenCount: 1),
          );
          expect(model.todayPillNumber, 22);
        });
      });
    });
  });
  group("#isActive", () {
    test("it is active pattern. today: 2020-09-19, begin: 2020-09-14", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-14"),
        lastTakenDate: null,
        createdAt: now(),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
        pills:
            Pill.testGenerateAndIterateTo(pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-14"), lastTakenDate: null, pillTakenCount: 1),
      );
      expect(model.isActive, true);
    });
    test("it is active pattern. Boundary testing. today: 2020-09-28, begin: 2020-09-01", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-01"),
        lastTakenDate: null,
        createdAt: now(),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
        pills:
            Pill.testGenerateAndIterateTo(pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-01"), lastTakenDate: null, pillTakenCount: 1),
      );
      expect(model.isActive, true);
    });
    test("it is deactive pattern. Boundary testing. today: 2020-09-29, begin: 2020-09-01", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-29"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-01"),
        lastTakenDate: null,
        createdAt: now(),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
        pills:
            Pill.testGenerateAndIterateTo(pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-01"), lastTakenDate: null, pillTakenCount: 1),
      );
      expect(model.isActive, false);
    });
    test("it is active pattern. Boundary testing. now: 2020-09-28 23:59:59, begin: 2020-09-01", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime(2020, 9, 28, 23, 59, 59));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-01"),
        lastTakenDate: null,
        createdAt: now(),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
        pills:
            Pill.testGenerateAndIterateTo(pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-01"), lastTakenDate: null, pillTakenCount: 1),
      );
      expect(model.isActive, true);
    });
    test("it is active pattern. for avoid out of active duration when during rest duration", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime(2020, 9, 29, 23, 59, 59));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-01"),
        lastTakenDate: null,
        createdAt: now(),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
        restDurations: [
          RestDuration(beginDate: DateTime.parse("2020-09-20"), createdDate: DateTime.parse("2020-09-20"), endDate: null),
        ],
        pills:
            Pill.testGenerateAndIterateTo(pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-01"), lastTakenDate: null, pillTakenCount: 1),
      );
      expect(model.isActive, true);
    });
    test("it is active pattern. for avoid out of active duration when contains ended rest duration", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime(2020, 9, 29, 23, 59, 59));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-01"),
        lastTakenDate: null,
        createdAt: now(),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
        restDurations: [
          RestDuration(beginDate: DateTime.parse("2020-09-20"), createdDate: DateTime.parse("2020-09-20"), endDate: DateTime.parse("2020-09-22")),
        ],
        pills:
            Pill.testGenerateAndIterateTo(pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-01"), lastTakenDate: null, pillTakenCount: 1),
      );
      expect(model.isActive, true);
    });
    test("it is deactive pattern. Boundary testing. now: 2020-09-29 23:59:59, begin: 2020-09-01", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime(2020, 9, 29, 23, 59, 59));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-01"),
        lastTakenDate: null,
        createdAt: now(),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
        pills:
            Pill.testGenerateAndIterateTo(pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-01"), lastTakenDate: null, pillTakenCount: 1),
      );
      expect(model.isActive, false);
    });
    test("it is deactive pattern.  now: 2020-06-29 begin: 2020-09-01", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-06-29"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-01"),
        lastTakenDate: null,
        createdAt: now(),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
        pills:
            Pill.testGenerateAndIterateTo(pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-01"), lastTakenDate: null, pillTakenCount: 1),
      );
      expect(model.isActive, false);
    });
    test("it is deactive pattern. for contains ended rest duration", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime(2020, 9, 30, 23, 59, 59));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-01"),
        lastTakenDate: null,
        createdAt: now(),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
        restDurations: [
          RestDuration(
            beginDate: DateTime.parse("2020-09-20"),
            createdDate: DateTime.parse("2020-09-20"),
            endDate: DateTime.parse("2020-09-21"),
          ),
        ],
        pills:
            Pill.testGenerateAndIterateTo(pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-01"), lastTakenDate: null, pillTakenCount: 1),
      );
      expect(model.isActive, false);
    });
  });
  group("#isBegan", () {
    test("it is not out of range pattern. today: 2020-09-19, begin: 2020-09-14", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-14"),
        lastTakenDate: null,
        createdAt: now(),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
        pills:
            Pill.testGenerateAndIterateTo(pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-14"), lastTakenDate: null, pillTakenCount: 1),
      );
      expect(model.isBegan, true);
    });
    test("it is not out of range pattern. Boundary testing. now: 2020-09-28, begin: 2020-09-01", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-01"),
        lastTakenDate: null,
        createdAt: now(),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
        pills:
            Pill.testGenerateAndIterateTo(pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-01"), lastTakenDate: null, pillTakenCount: 1),
      );
      expect(model.isBegan, true);
    });
    test("it is out of range pattern. Boundary testing. now: 2020-09-29, begin: 2020-09-01", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-29"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-01"),
        lastTakenDate: null,
        createdAt: now(),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
        pills:
            Pill.testGenerateAndIterateTo(pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-01"), lastTakenDate: null, pillTakenCount: 1),
      );
      expect(model.isBegan, true);
    });
    test("it is out of range pattern. now: 2020-06-29, begin: 2020-09-01", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-06-29"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-01"),
        lastTakenDate: null,
        createdAt: now(),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
        pills:
            Pill.testGenerateAndIterateTo(pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-01"), lastTakenDate: null, pillTakenCount: 1),
      );
      expect(model.isBegan, false);
    });
  });
  group("#lastCompletedPillNumber", () {
    group("pillTakenCount = 1", () {
      const pillTakenCount = 1;
      test("未服用の場合は0になる", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-14"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          pillTakenCount: pillTakenCount,
          pills: Pill.testGenerateAndIterateTo(
              pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-14"), lastTakenDate: null, pillTakenCount: pillTakenCount),
        );
        expect(model.lastCompletedPillNumber, 0);
      });
      test("6日目だが4番まで服用済み", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-14"),
          lastTakenDate: DateTime.parse("2020-09-17"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          pillTakenCount: pillTakenCount,
          pills: Pill.testGenerateAndIterateTo(
              pillSheetType: sheetType,
              fromDate: DateTime.parse("2020-09-14"),
              lastTakenDate: DateTime.parse("2020-09-17"),
              pillTakenCount: pillTakenCount),
        );
        expect(model.lastCompletedPillNumber, 4);
      });
      test("境界値テスト。28番を服用", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          pillTakenCount: pillTakenCount,
          pills: Pill.testGenerateAndIterateTo(
              pillSheetType: sheetType,
              fromDate: DateTime.parse("2020-09-01"),
              lastTakenDate: DateTime.parse("2020-09-28"),
              pillTakenCount: pillTakenCount),
        );
        expect(model.lastCompletedPillNumber, 28);
      });
      test("服用お休み期間がある場合。服用お休みが終了してない場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-22"),
          createdAt: now(),
          restDurations: [
            RestDuration(
              beginDate: DateTime.parse("2020-09-23"),
              createdDate: DateTime.parse("2020-09-23"),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          pillTakenCount: pillTakenCount,
          pills: Pill.testGenerateAndIterateTo(
              pillSheetType: sheetType,
              fromDate: DateTime.parse("2020-09-01"),
              lastTakenDate: DateTime.parse("2020-09-22"),
              pillTakenCount: pillTakenCount),
        );
        expect(model.lastCompletedPillNumber, 22);
      });
      test("服用お休み期間がある場合。服用お休みが終了している場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-27"),
          createdAt: now(),
          restDurations: [
            RestDuration(
              beginDate: DateTime.parse("2020-09-23"),
              createdDate: DateTime.parse("2020-09-23"),
              endDate: DateTime.parse("2020-09-25"),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          pillTakenCount: pillTakenCount,
          pills: Pill.testGenerateAndIterateTo(
              pillSheetType: sheetType,
              fromDate: DateTime.parse("2020-09-01"),
              lastTakenDate: DateTime.parse("2020-09-27"),
              pillTakenCount: pillTakenCount),
        );
        expect(model.lastCompletedPillNumber, 25);
      });
      test("服用お休みが終了しているが、まだピルを服用していない場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          restDurations: [
            RestDuration(
              beginDate: DateTime.parse("2020-09-23"),
              createdDate: DateTime.parse("2020-09-23"),
              endDate: DateTime.parse("2020-09-25"),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          pillTakenCount: pillTakenCount,
          pills: Pill.testGenerateAndIterateTo(
              pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-01"), lastTakenDate: null, pillTakenCount: pillTakenCount),
        );
        expect(model.lastCompletedPillNumber, 0);
      });

      group("服用お休みを同じピルシートで複数している場合", () {
        test("最後の服用お休みが終了していない場合", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

          const sheetType = PillSheetType.pillsheet_21;
          final model = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-22"),
            createdAt: now(),
            restDurations: [
              RestDuration(
                beginDate: DateTime.parse("2020-09-12"),
                createdDate: DateTime.parse("2020-09-12"),
                endDate: DateTime.parse("2020-09-15"),
              ),
              RestDuration(
                beginDate: DateTime.parse("2020-09-26"),
                createdDate: DateTime.parse("2020-09-26"),
              ),
            ],
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
            pillTakenCount: pillTakenCount,
            pills: Pill.testGenerateAndIterateTo(
                pillSheetType: sheetType,
                fromDate: DateTime.parse("2020-09-01"),
                lastTakenDate: DateTime.parse("2020-09-22"),
                pillTakenCount: pillTakenCount),
          );
          expect(model.lastCompletedPillNumber, 19);
        });
        test("最後の服用お休みが終了している場合", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

          const sheetType = PillSheetType.pillsheet_21;
          final model = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-22"),
            createdAt: now(),
            restDurations: [
              RestDuration(
                beginDate: DateTime.parse("2020-09-12"),
                createdDate: DateTime.parse("2020-09-12"),
                endDate: DateTime.parse("2020-09-15"),
              ),
              RestDuration(
                beginDate: DateTime.parse("2020-09-26"),
                createdDate: DateTime.parse("2020-09-26"),
                endDate: DateTime.parse("2020-09-27"),
              ),
            ],
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
            pillTakenCount: pillTakenCount,
            pills: Pill.testGenerateAndIterateTo(
              pillSheetType: sheetType,
              fromDate: DateTime.parse("2020-09-01"),
              lastTakenDate: DateTime.parse("2020-09-22"),
              pillTakenCount: pillTakenCount,
            ),
          );
          expect(model.lastCompletedPillNumber, 19);
        });
      });
    });
    group("pillTakenCount = 2", () {
      const pillTakenCount = 2;
      test("未服用の場合は0になる", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-14"),
          lastTakenDate: null,
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          pillTakenCount: pillTakenCount,
          pills: Pill.testGenerateAndIterateTo(
              pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-14"), lastTakenDate: null, pillTakenCount: pillTakenCount),
        );
        expect(model.lastCompletedPillNumber, 0);
      });
      test("6日目だが4番まで服用済み", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-14"),
          lastTakenDate: DateTime.parse("2020-09-17"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          pillTakenCount: pillTakenCount,
          pills: Pill.testGenerateAndIterateTo(
              pillSheetType: sheetType,
              fromDate: DateTime.parse("2020-09-14"),
              lastTakenDate: DateTime.parse("2020-09-17"),
              pillTakenCount: pillTakenCount),
        );
        expect(model.lastCompletedPillNumber, 4);
      });
      test("境界値テスト。28番を服用", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-28"),
          createdAt: now(),
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          pillTakenCount: pillTakenCount,
          pills: Pill.testGenerateAndIterateTo(
              pillSheetType: sheetType,
              fromDate: DateTime.parse("2020-09-01"),
              lastTakenDate: DateTime.parse("2020-09-28"),
              pillTakenCount: pillTakenCount),
        );
        expect(model.lastCompletedPillNumber, 28);
      });
      test("服用お休み期間がある場合。服用お休みが終了してない場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-22"),
          createdAt: now(),
          restDurations: [
            RestDuration(
              beginDate: DateTime.parse("2020-09-23"),
              createdDate: DateTime.parse("2020-09-23"),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          pillTakenCount: pillTakenCount,
          pills: Pill.testGenerateAndIterateTo(
              pillSheetType: sheetType,
              fromDate: DateTime.parse("2020-09-01"),
              lastTakenDate: DateTime.parse("2020-09-22"),
              pillTakenCount: pillTakenCount),
        );
        expect(model.lastCompletedPillNumber, 22);
      });
      test("服用お休み期間がある場合。服用お休みが終了している場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-27"),
          createdAt: now(),
          restDurations: [
            RestDuration(
              beginDate: DateTime.parse("2020-09-23"),
              createdDate: DateTime.parse("2020-09-23"),
              endDate: DateTime.parse("2020-09-25"),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          pillTakenCount: pillTakenCount,
          pills: Pill.testGenerateAndIterateTo(
              pillSheetType: sheetType,
              fromDate: DateTime.parse("2020-09-01"),
              lastTakenDate: DateTime.parse("2020-09-27"),
              pillTakenCount: pillTakenCount),
        );
        expect(model.lastCompletedPillNumber, 25);
      });
      test("服用お休みが終了しているが、まだピルを服用していない場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: null,
          createdAt: now(),
          restDurations: [
            RestDuration(
              beginDate: DateTime.parse("2020-09-23"),
              createdDate: DateTime.parse("2020-09-23"),
              endDate: DateTime.parse("2020-09-25"),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          pillTakenCount: pillTakenCount,
          pills: Pill.testGenerateAndIterateTo(
              pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-01"), lastTakenDate: null, pillTakenCount: pillTakenCount),
        );
        expect(model.lastCompletedPillNumber, 0);
      });

      group("服用お休みを同じピルシートで複数している場合", () {
        test("最後の服用お休みが終了していない場合", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

          const sheetType = PillSheetType.pillsheet_21;
          final model = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-22"),
            createdAt: now(),
            restDurations: [
              RestDuration(
                beginDate: DateTime.parse("2020-09-12"),
                createdDate: DateTime.parse("2020-09-12"),
                endDate: DateTime.parse("2020-09-15"),
              ),
              RestDuration(
                beginDate: DateTime.parse("2020-09-26"),
                createdDate: DateTime.parse("2020-09-26"),
              ),
            ],
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
            pillTakenCount: pillTakenCount,
            pills: Pill.testGenerateAndIterateTo(
                pillSheetType: sheetType,
                fromDate: DateTime.parse("2020-09-01"),
                lastTakenDate: DateTime.parse("2020-09-22"),
                pillTakenCount: pillTakenCount),
          );
          expect(model.lastCompletedPillNumber, 19);
        });
        test("最後の服用お休みが終了している場合", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

          const sheetType = PillSheetType.pillsheet_21;
          final model = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2020-09-01"),
            lastTakenDate: DateTime.parse("2020-09-22"),
            createdAt: now(),
            restDurations: [
              RestDuration(
                beginDate: DateTime.parse("2020-09-12"),
                createdDate: DateTime.parse("2020-09-12"),
                endDate: DateTime.parse("2020-09-15"),
              ),
              RestDuration(
                beginDate: DateTime.parse("2020-09-26"),
                createdDate: DateTime.parse("2020-09-26"),
                endDate: DateTime.parse("2020-09-27"),
              ),
            ],
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
            pillTakenCount: pillTakenCount,
            pills: Pill.testGenerateAndIterateTo(
              pillSheetType: sheetType,
              fromDate: DateTime.parse("2020-09-01"),
              lastTakenDate: DateTime.parse("2020-09-22"),
              pillTakenCount: pillTakenCount,
            ),
          );
          expect(model.lastCompletedPillNumber, 19);
        });
      });
    });
  });
  group("#lastTakenPillNumber", () {
    test("未服用の場合は0になる", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-14"),
        lastTakenDate: null,
        createdAt: now(),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
        pills:
            Pill.testGenerateAndIterateTo(pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-14"), lastTakenDate: null, pillTakenCount: 1),
      );
      expect(model.lastTakenPillNumber, 0);
    });
    test("6日目だが4番まで服用済み", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-19"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-14"),
        lastTakenDate: DateTime.parse("2020-09-17"),
        createdAt: now(),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
        pills: Pill.testGenerateAndIterateTo(
            pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-14"), lastTakenDate: DateTime.parse("2020-09-17"), pillTakenCount: 1),
      );
      expect(model.lastTakenPillNumber, 4);
    });
    test("境界値テスト。28番を服用", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-01"),
        lastTakenDate: DateTime.parse("2020-09-28"),
        createdAt: now(),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
        pills: Pill.testGenerateAndIterateTo(
            pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-01"), lastTakenDate: DateTime.parse("2020-09-28"), pillTakenCount: 1),
      );
      expect(model.lastTakenPillNumber, 28);
    });
    test("服用お休み期間がある場合。服用お休みが終了してない場合", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-01"),
        lastTakenDate: DateTime.parse("2020-09-22"),
        createdAt: now(),
        restDurations: [
          RestDuration(
            beginDate: DateTime.parse("2020-09-23"),
            createdDate: DateTime.parse("2020-09-23"),
          ),
        ],
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
        pills: Pill.testGenerateAndIterateTo(
            pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-01"), lastTakenDate: DateTime.parse("2020-09-22"), pillTakenCount: 1),
      );
      expect(model.lastTakenPillNumber, 22);
    });
    test("服用お休み期間がある場合。服用お休みが終了している場合", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-01"),
        lastTakenDate: DateTime.parse("2020-09-27"),
        createdAt: now(),
        restDurations: [
          RestDuration(
            beginDate: DateTime.parse("2020-09-23"),
            createdDate: DateTime.parse("2020-09-23"),
            endDate: DateTime.parse("2020-09-25"),
          ),
        ],
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
        pills: Pill.testGenerateAndIterateTo(
            pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-01"), lastTakenDate: DateTime.parse("2020-09-27"), pillTakenCount: 1),
      );
      expect(model.lastTakenPillNumber, 25);
    });
    test("服用お休みが終了しているが、まだピルを服用していない場合", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

      const sheetType = PillSheetType.pillsheet_21;
      final model = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2020-09-01"),
        lastTakenDate: null,
        createdAt: now(),
        restDurations: [
          RestDuration(
            beginDate: DateTime.parse("2020-09-23"),
            createdDate: DateTime.parse("2020-09-23"),
            endDate: DateTime.parse("2020-09-25"),
          ),
        ],
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
        pills:
            Pill.testGenerateAndIterateTo(pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-01"), lastTakenDate: null, pillTakenCount: 1),
      );
      expect(model.lastTakenPillNumber, 0);
    });

    group("服用お休みを同じピルシートで複数している場合", () {
      test("最後の服用お休みが終了していない場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-22"),
          createdAt: now(),
          restDurations: [
            RestDuration(
              beginDate: DateTime.parse("2020-09-12"),
              createdDate: DateTime.parse("2020-09-12"),
              endDate: DateTime.parse("2020-09-15"),
            ),
            RestDuration(
              beginDate: DateTime.parse("2020-09-26"),
              createdDate: DateTime.parse("2020-09-26"),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          pills: Pill.testGenerateAndIterateTo(
              pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-01"), lastTakenDate: DateTime.parse("2020-09-22"), pillTakenCount: 1),
        );
        expect(model.lastTakenPillNumber, 19);
      });
      test("最後の服用お休みが終了している場合", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2020-09-28"));

        const sheetType = PillSheetType.pillsheet_21;
        final model = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2020-09-01"),
          lastTakenDate: DateTime.parse("2020-09-22"),
          createdAt: now(),
          restDurations: [
            RestDuration(
              beginDate: DateTime.parse("2020-09-12"),
              createdDate: DateTime.parse("2020-09-12"),
              endDate: DateTime.parse("2020-09-15"),
            ),
            RestDuration(
              beginDate: DateTime.parse("2020-09-26"),
              createdDate: DateTime.parse("2020-09-26"),
              endDate: DateTime.parse("2020-09-27"),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          pills: Pill.testGenerateAndIterateTo(
              pillSheetType: sheetType, fromDate: DateTime.parse("2020-09-01"), lastTakenDate: DateTime.parse("2020-09-22"), pillTakenCount: 1),
        );
        expect(model.lastTakenPillNumber, 19);
      });
    });
  });
  group("#estimatedEndTakenDate", () {
    test("spec", () {
      final mockTodayRepository = MockTodayService();
      todayRepository = mockTodayRepository;
      when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

      const sheetType = PillSheetType.pillsheet_21;
      final pillSheet = PillSheet(
        id: firestoreIDGenerator(),
        beginingDate: DateTime.parse("2022-05-01"),
        lastTakenDate: null,
        createdAt: now(),
        typeInfo: PillSheetTypeInfo(
          dosingPeriod: sheetType.dosingPeriod,
          name: sheetType.fullName,
          totalCount: sheetType.totalCount,
          pillSheetTypeReferencePath: sheetType.rawPath,
        ),
        pills:
            Pill.testGenerateAndIterateTo(pillSheetType: sheetType, fromDate: DateTime.parse("2022-05-01"), lastTakenDate: null, pillTakenCount: 1),
      );
      expect(pillSheet.estimatedEndTakenDate, DateTime.parse("2022-05-29").subtract(const Duration(seconds: 1)));
    });

    group("pillsheet has rest durations", () {
      test("rest duration is not ended", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2022-05-01"),
          lastTakenDate: null,
          createdAt: now(),
          restDurations: [
            RestDuration(
              beginDate: DateTime.parse("2022-05-03"),
              createdDate: DateTime.parse("2022-05-03"),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          pills:
              Pill.testGenerateAndIterateTo(pillSheetType: sheetType, fromDate: DateTime.parse("2022-05-01"), lastTakenDate: null, pillTakenCount: 1),
        );
        expect(pillSheet.estimatedEndTakenDate, DateTime.parse("2022-06-05").subtract(const Duration(seconds: 1)));
      });
      test("rest duration is ended", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

        const sheetType = PillSheetType.pillsheet_21;
        final pillSheet = PillSheet(
          id: firestoreIDGenerator(),
          beginingDate: DateTime.parse("2022-05-01"),
          lastTakenDate: null,
          createdAt: now(),
          restDurations: [
            RestDuration(
              beginDate: DateTime.parse("2022-05-03"),
              createdDate: DateTime.parse("2022-05-03"),
              endDate: DateTime.parse("2022-05-05"),
            ),
          ],
          typeInfo: PillSheetTypeInfo(
            dosingPeriod: sheetType.dosingPeriod,
            name: sheetType.fullName,
            totalCount: sheetType.totalCount,
            pillSheetTypeReferencePath: sheetType.rawPath,
          ),
          pills:
              Pill.testGenerateAndIterateTo(pillSheetType: sheetType, fromDate: DateTime.parse("2022-05-01"), lastTakenDate: null, pillTakenCount: 1),
        );
        expect(pillSheet.estimatedEndTakenDate, DateTime.parse("2022-05-31").subtract(const Duration(seconds: 1)));
      });

      group("pillsheet has plural rest duration", () {
        test("last rest duration is not ended", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2022-05-01"),
            lastTakenDate: null,
            createdAt: now(),
            restDurations: [
              RestDuration(
                beginDate: DateTime.parse("2022-05-03"),
                createdDate: DateTime.parse("2022-05-03"),
                endDate: DateTime.parse("2022-05-05"),
              ),
              RestDuration(
                beginDate: DateTime.parse("2022-05-07"),
                createdDate: DateTime.parse("2022-05-07"),
              ),
            ],
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
            pills: Pill.testGenerateAndIterateTo(
                pillSheetType: sheetType, fromDate: DateTime.parse("2022-05-01"), lastTakenDate: null, pillTakenCount: 1),
          );
          expect(pillSheet.estimatedEndTakenDate, DateTime.parse("2022-06-03").subtract(const Duration(seconds: 1)));
        });
        test("last rest duration is ended", () {
          final mockTodayRepository = MockTodayService();
          todayRepository = mockTodayRepository;
          when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

          const sheetType = PillSheetType.pillsheet_21;
          final pillSheet = PillSheet(
            id: firestoreIDGenerator(),
            beginingDate: DateTime.parse("2022-05-01"),
            lastTakenDate: null,
            createdAt: now(),
            restDurations: [
              RestDuration(
                beginDate: DateTime.parse("2022-05-03"),
                createdDate: DateTime.parse("2022-05-03"),
                endDate: DateTime.parse("2022-05-05"),
              ),
              RestDuration(
                beginDate: DateTime.parse("2022-05-07"),
                createdDate: DateTime.parse("2022-05-07"),
                endDate: DateTime.parse("2022-05-08"),
              ),
            ],
            typeInfo: PillSheetTypeInfo(
              dosingPeriod: sheetType.dosingPeriod,
              name: sheetType.fullName,
              totalCount: sheetType.totalCount,
              pillSheetTypeReferencePath: sheetType.rawPath,
            ),
            pills: Pill.testGenerateAndIterateTo(
                pillSheetType: sheetType, fromDate: DateTime.parse("2022-05-01"), lastTakenDate: null, pillTakenCount: 1),
          );
          expect(pillSheet.estimatedEndTakenDate, DateTime.parse("2022-06-01").subtract(const Duration(seconds: 1)));
        });
      });
    });
    group("#summarizedRestDuration", () {
      test("restDurations isEmpty", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

        expect(summarizedRestDuration(restDurations: [], upperDate: today()), 0);
      });
      test("last restDuration is not ended", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

        final restDurations = [
          RestDuration(
            beginDate: DateTime.parse("2022-05-07"),
            createdDate: DateTime.parse("2022-05-07"),
          ),
        ];
        expect(summarizedRestDuration(restDurations: restDurations, upperDate: today()), 3);
      });
      test("last restDuration is ended", () {
        final mockTodayRepository = MockTodayService();
        todayRepository = mockTodayRepository;
        when(mockTodayRepository.now()).thenReturn(DateTime.parse("2022-05-10"));

        final restDurations = [
          RestDuration(
            beginDate: DateTime.parse("2022-05-07"),
            createdDate: DateTime.parse("2022-05-07"),
            endDate: DateTime.parse("2022-05-08"),
          ),
        ];
        expect(summarizedRestDuration(restDurations: restDurations, upperDate: today()), 1);
      });
    });
  });
}
