import 'package:pilll/entity/initial_setting.dart';
import 'package:pilll/entity/pill_sheet_type.dart';
import 'package:pilll/service/initial_setting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/mock.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  group("#register", () {
    test("when today pill number is not null", () async {
      final initialSetting = InitialSettingModel.initial(
        todayPillNumber: 1,
        pillSheetType: PillSheetType.pillsheet_21,
      );
      final batch = MockBatchFactory();
      when(batch.batch()).thenReturn(MockWriteBatch());

      final settingService = MockSettingService();
      final settingEntity = initialSetting.buildSetting();
      when(settingService.update(settingEntity))
          .thenAnswer((realInvocation) => Future.value(settingEntity));

      final pillSheetEntity = initialSetting.buildPillSheet();
      final pillSheetService = MockPillSheetService();
      when(pillSheetService.register(any, pillSheetEntity!))
          .thenAnswer((realInvocation) => "ID");
      final pillSheetModifedHistoryService =
          MockPillSheetModifiedHistoryService();
      when(pillSheetModifedHistoryService.update(any))
          .thenAnswer((_) => Future.value());

      final service = InitialSettingService(batch, settingService,
          pillSheetService, pillSheetModifedHistoryService);
      await service.register(initialSetting);

      verify(settingService.update(settingEntity));
      verify(pillSheetService.register(any, pillSheetEntity));
    });
  });
}
