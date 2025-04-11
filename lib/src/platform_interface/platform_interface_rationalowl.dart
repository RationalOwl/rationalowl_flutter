import 'dart:async';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../device_register_result_listener.dart';
import '../message_listener.dart';
import '../method_channel/method_channel_rationalowl.dart';

abstract class MinervaManagerPlatform extends PlatformInterface {
  static MinervaManagerPlatform? _instance;
  static final Object _token = Object();

  static MinervaManagerPlatform get instance {
    return _instance ??= MethodChannelMinervaManager.instance;
  }

  static set instance(MinervaManagerPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  MinervaManagerPlatform() : super(token: _token);

  //#region set listener/clear listener
  Future<void> setRegisterResultListener(
    DeviceRegisterResultListener listener,
  ) async {
    throw UnimplementedError('setRegisterResultListener() is not implemented');
  }

  Future<void> clearRegisterResultListener() async {
    throw UnimplementedError(
      'clearRegisterResultListener() is not implemented',
    );
  }

  Future<void> setMsgListener(MessageListener listener) async {
    throw UnimplementedError('setMsgListener() is not implemented');
  }

  Future<void> clearMsgListener() async {
    throw UnimplementedError('clearMsgListener() is not implemented');
  }

  //#endregion

  //#region life cycle
  Future<void> becomeActive() async {
    throw UnimplementedError('becomeActive() is not implemented');
  }

  Future<void> enterBackground() async {
    throw UnimplementedError('enterBackground() is not implemented');
  }

  Future<void> setDeviceToken(String deviceToken) async {
    throw UnimplementedError('setDeviceToken() is not implemented');
  }

  Future<void> setAppGroup(String appGroup) async {
    throw UnimplementedError('setAppGroup() is not implemented');
  }

  Future<void> enableNotificationTracking({
    required Map<String, dynamic> data,
    String? appGroup,
  }) async {
    throw UnimplementedError('enableNotificationTracking() is not implemented');
  }

  Future<void> registerDevice({
    required String gateHost,
    required String serviceId,
    String? deviceRegName,
  }) async {
    throw UnimplementedError('registerDevice() is not implemented');
  }

  Future<void> unregisterDevice({required String serviceId}) async {
    throw UnimplementedError('unregisterDevice() is not implemented');
  }

  Future<bool> isDeviceAppRegister({
    required String serviceId,
    required String deviceRegId,
  }) async {
    throw UnimplementedError('isDeviceAppRegister() is not implemented');
  }

  Future<String?> sendUpstreamMsg({
    required String data,
    required String serverRegId,
  }) async {
    throw UnimplementedError('sendUpstreamMsg() is not implemented');
  }

  Future<String?> sendP2PMsg({
    required String data,
    required List<String> destDevices,
    bool supportMsgQ = true,
    String? notiTitle,
    String? notiBody,
  }) async {
    throw UnimplementedError('sendP2PMsg() is not implemented');
  }

  //#endregion
}
