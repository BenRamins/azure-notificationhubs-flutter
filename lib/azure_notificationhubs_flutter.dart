import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

typedef Future<dynamic>? MessageHandler(Map<String, dynamic> message);
typedef Future<dynamic>? TokenHandler(String token);

class AzureNotificationhubsFlutter {
  static const MethodChannel _channel =
      MethodChannel('azure_notificationhubs_flutter');

  MessageHandler? _onMessage;
  MessageHandler? _onResume;
  MessageHandler? _onLaunch;
  TokenHandler? _onToken;

  /// Sets up [MessageHandler] for incoming messages.
  void configure({
    MessageHandler? onMessage,
    MessageHandler? onResume,
    MessageHandler? onLaunch,
    TokenHandler? onToken,
  }) {
    _onMessage = onMessage;
    _onLaunch = onLaunch;
    _onResume = onResume;
    _onToken = onToken;
    _channel.setMethodCallHandler(_handleMethod);
    _channel.invokeMethod<void>('configure');
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "onToken":
        return _onToken?.call(call.arguments) ?? Future.value();
      case "onMessage":
        if (Platform.isAndroid) {
          Map<String, dynamic> args = Map<String, dynamic>.from(call.arguments);
          return _onMessage?.call(Map<String, dynamic>.from(args['data'])) ??
              Future.value();
        }
        return _onMessage?.call(call.arguments.cast<String, dynamic>()) ??
            Future.value();
      case "onLaunch":
        if (Platform.isAndroid) {
          Map<String, dynamic> args = Map<String, dynamic>.from(call.arguments);
          return _onMessage?.call(Map<String, dynamic>.from(args['data'])) ??
              Future.value();
        }
        return _onLaunch?.call(call.arguments.cast<String, dynamic>()) ??
            Future.value();
      case "onResume":
        if (Platform.isAndroid) {
          Map<String, dynamic> args = Map<String, dynamic>.from(call.arguments);
          return _onMessage?.call(Map<String, dynamic>.from(args['data'])) ??
              Future.value();
        }
        return _onResume?.call(call.arguments.cast<String, dynamic>()) ??
            Future.value();
      default:
        throw UnsupportedError("Unrecognized JSON message");
    }
  }
}
