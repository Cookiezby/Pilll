import 'package:firebase_analytics/firebase_analytics.dart';

abstract class AbstractAnalytics {
  Future<void> logEvent(
      {required String name, Map<String, dynamic>? parameters});
  Future<void> setCurrentScreen(
      {required String screenName, String screenClassOverride = 'Flutter'});
}

final firebaseAnalytics = FirebaseAnalytics();

class Analytics extends AbstractAnalytics {
  @override
  Future<void> logEvent(
      {required String name, Map<String, dynamic>? parameters}) async {
    assert(name.length <= 40,
        "firebase analytics log event name limit length up to 40");
    return firebaseAnalytics.logEvent(name: name, parameters: parameters);
  }

  @override
  Future<void> setCurrentScreen(
      {required String screenName,
      String screenClassOverride = 'Flutter'}) async {
    firebaseAnalytics.logEvent(name: "screen_$screenName");
    return firebaseAnalytics.setCurrentScreen(
        screenName: screenName, screenClassOverride: screenClassOverride);
  }
}

AbstractAnalytics analytics = Analytics();
