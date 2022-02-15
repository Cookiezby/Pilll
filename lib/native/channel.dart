import 'package:flutter/services.dart';
import 'package:pilll/native/legacy.dart';
import 'package:pilll/native/pill.dart';

final methodChannel = MethodChannel("method.channel.MizukiOhashi.Pilll");
definedChannel() {
  methodChannel.setMethodCallHandler((MethodCall call) async {
    switch (call.method) {
      case 'recordPill':
        return recordPill();
      case "salvagedOldStartTakenDate":
        return salvagedOldStartTakenDate(call.arguments)
            .catchError((error) => print(error));
      default:
        break;
    }
  });
}
