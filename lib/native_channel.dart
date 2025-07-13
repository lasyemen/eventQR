import 'package:flutter/services.dart';

class NativeChannel {
  static const MethodChannel _channel = MethodChannel('custom_channel');

  static Future<String> callCustomMethod(String param) async {
    try {
      final result = await _channel.invokeMethod(
        'customMethod',
        {'param': param},
      );
      return result as String;
    } on PlatformException catch (e) {
      return "Error: ${e.message}";
    }
  }

  static Future<String> getDeviceInfo() async {
    try {
      return await _channel.invokeMethod('getDeviceInfo') as String;
    } on PlatformException catch (e) {
      return "Error: ${e.message}";
    }
  }

  static Future<bool> openNativeScreen() async {
    try {
      return await _channel.invokeMethod('openNativeScreen') as bool;
    } on PlatformException {
      return false;
    }
  }
}