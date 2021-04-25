import 'package:pilll/analytics.dart';
import 'package:pilll/service/pill_sheet.dart';
import 'package:pilll/service/setting.dart';
import 'package:pilll/service/day.dart';
import 'package:mockito/mockito.dart';

class MockPillSheetRepository extends Mock implements PillSheetService {}

class MockTodayRepository extends Mock implements TodayServiceInterface {}

class MockSettingService extends Mock implements SettingService {}

class MockPillSheetService extends Mock implements PillSheetService {}

class MockAnalytics extends Mock implements AbstractAnalytics {}
