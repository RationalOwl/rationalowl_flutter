import 'package:flutter/services.dart';

import '../device_register_result_listener.dart';
import '../message_listener.dart';
import '../platform_interface/platform_interface_rationalowl.dart';

class MethodChannelMinervaManager extends MinervaManagerPlatform {
  static const MethodChannel _channel = MethodChannel(
    'plugins.rationalowl.com/rationalowl_flutter',
  );
  static MethodChannelMinervaManager? _instance;

  static MethodChannelMinervaManager get instance {
    return _instance ??= MethodChannelMinervaManager._();
  }

  DeviceRegisterResultListener? _deviceRegisterResultListener;
  MessageListener? _messageListener;

  MethodChannelMinervaManager._() {
    _setMethodCallHandlers();
  }

  void _setMethodCallHandlers() {
    _channel.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case 'DeviceRegisterResultListener#onRegisterResult':
          if (_deviceRegisterResultListener != null) {
            final map = Map<String, dynamic>.from(call.arguments);
            _deviceRegisterResultListener!.onRegisterResult(
              map['resultCode'],
              map['resultMsg'],
              map['deviceRegId'],
            );
          }
          break;
        case 'DeviceRegisterResultListener#onUnregisterResult':
          if (_deviceRegisterResultListener != null) {
            final map = Map<String, dynamic>.from(call.arguments);
            _deviceRegisterResultListener!.onUnregisterResult(
              map['resultCode'],
              map['resultMsg'],
            );
          }
          break;
        case 'MessageListener#onDownstreamMsgRecieved':
          final msgList =
              call.arguments
                  .map((json) => Map<String, dynamic>.from(json))
                  .toList(growable: false)
                  .cast<Map<String, dynamic>>();
          _messageListener?.onDownstreamMsgReceived(msgList);
          break;
        case 'MessageListener#onP2PMsgRecieved':
          final msgList =
              call.arguments
                  .map((json) => Map<String, dynamic>.from(json))
                  .toList(growable: false)
                  .cast<Map<String, dynamic>>();
          _messageListener?.onP2PMsgReceived(msgList);
          break;
        case 'MessageListener#onPushMsgRecieved':
          final msgList =
              call.arguments
                  .map((json) => Map<String, dynamic>.from(json))
                  .toList(growable: false)
                  .cast<Map<String, dynamic>>();
          _messageListener?.onPushMsgReceived(msgList);
          break;
        case 'MessageListener#onSendUpstreamMsgResult':
          if (_messageListener != null) {
            final map = Map<String, dynamic>.from(call.arguments);
            _messageListener!.onSendUpstreamMsgResult(
              map['resultCode'],
              map['resultMsg'],
              map['msgId'],
            );
          }
          break;
        default:
          throw UnimplementedError('${call.method} has not been implemented');
      }
    });
  }

  //#region set listener/clear listener
  @override
  Future<void> setRegisterResultListener(
    DeviceRegisterResultListener listener,
  ) async {
    _deviceRegisterResultListener = listener;
    await _channel.invokeMethod('MinervaManager#setRegisterResultListener');
  }

  @override
  Future<void> clearRegisterResultListener() async {
    _deviceRegisterResultListener = null;
    await _channel.invokeMethod('MinervaManager#clearRegisterResultListener');
  }

  @override
  Future<void> setMsgListener(MessageListener listener) async {
    _messageListener = listener;
    await _channel.invokeMethod('MinervaManager#setMsgListener');
  }

  @override
  Future<void> clearMsgListener() async {
    _messageListener = null;
    await _channel.invokeMethod('MinervaManager#clearMsgListener');
  }

  //#endregion

  //#region life cycle
  @override
  Future<void> becomeActive() async {
    await _channel.invokeMethod('MinervaManager#becomeActive');
  }

  @override
  Future<void> enterBackground() async {
    await _channel.invokeMethod('MinervaManager#enterBackground');
  }

  @override
  Future<void> setDeviceToken(String deviceToken) async {
    await _channel.invokeMapMethod('MinervaManager#setDeviceToken', {
      'deviceToken': deviceToken,
    });
  }

  @override
  Future<void> setAppGroup(String appGroup) async {
    await _channel.invokeMapMethod('MinervaManager#setAppGroup', {
      'appGroup': appGroup,
    });
  }

  @override
  Future<void> enableNotificationTracking({
    required Map<String, dynamic> data,
    String? appGroup,
  }) async {
    await _channel.invokeMethod('MinervaManager#enableNotificationTracking', {
      'data': data,
      if (appGroup != null) 'appGroup': appGroup,
    });
  }

  @override
  Future<void> registerDevice({
    required String gateHost,
    required String serviceId,
    String? deviceRegName,
  }) async {
    await _channel.invokeMapMethod('MinervaManager#registerDevice', {
      'gateHost': gateHost,
      'serviceId': serviceId,
      'deviceRegName': deviceRegName,
    });
  }

  @override
  Future<void> unregisterDevice({required String serviceId}) async {
    await _channel.invokeMapMethod('MinervaManager#unregisterDevice', {
      'serviceId': serviceId,
    });
  }

  @override
  Future<bool> isDeviceAppRegister({
    required String serviceId,
    required String deviceRegId,
  }) async {
    return (await _channel.invokeMethod('MinervaManager#isDeviceAppRegister', {
      'serviceId': serviceId,
      'deviceRegId': deviceRegId,
    }))!;
  }

  @override
  Future<String?> sendUpstreamMsg({
    required String data,
    required String serverRegId,
  }) async {
    return (await _channel.invokeMethod('MinervaManager#sendUpstreamMsg', {
      'data': data,
      'serverRegId': serverRegId,
    }))!;
  }

  @override
  Future<String?> sendP2PMsg({
    required String data,
    required List<String> destDevices,
    bool supportMsgQ = true,
    String? notiTitle,
    String? notiBody,
  }) async {
    return (await _channel.invokeMethod('MinervaManager#sendP2PMsg', {
      'data': data,
      'destDevices': destDevices,
      'supportMsgQ': supportMsgQ,
      'notiTitle': notiTitle,
      'notiBody': notiBody,
    }))!;
  }

  //#endregion
}
