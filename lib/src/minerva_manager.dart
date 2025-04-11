import 'device_register_result_listener.dart';
import 'message_listener.dart';
import 'platform_interface/platform_interface_rationalowl.dart';

class MinervaManager {
  static MinervaManager? _instance;

  static MinervaManager getInstance() {
    return _instance ??= MinervaManager._();
  }

  MinervaManagerPlatform? _delegatePackingProperty;

  MinervaManager._();

  MinervaManagerPlatform get _delegate {
    return _delegatePackingProperty ??= MinervaManagerPlatform.instance;
  }

  //#region set listener/clear listener
  /// 단말앱 등록 결과를 처리할 리스너를 등록한다.
  ///
  /// - [listener]: `registerDevice()` API를 통해 등록 요청한 결과를 처리할 리스너
  /// `registerDevice()` API 호출시 [listener]의 `onRegisterResult()` 콜백에서 결과를 처리한다.
  Future<void> setRegisterResultListener(
    DeviceRegisterResultListener listener,
  ) async {
    await _delegate.setRegisterResultListener(listener);
  }

  /// 단말앱 등록 결과 리스너를 해제한다.
  ///
  /// 이후 `DeviceRegisterResultListener`의 콜백이 호출되지 않는다.
  Future<void> clearRegisterResultListener() async {
    await _delegate.clearRegisterResultListener();
  }

  /// 다운스트림 메시지 발신 결과와 업스트림 메시지 수신을 처리할 리스너를 등록한다.
  ///
  /// - [listener]: 다운스트림 메시지 발신 결과와 업스트림 메시지 수신시 처리할 리스너
  Future<void> setMsgListener(MessageListener listener) async {
    await _delegate.setMsgListener(listener);
  }

  /// 앱 서버에서 등록한 메시지 리스너를 해제한다.
  ///
  /// 이후 `MessageListener`의 콜백이 호출되지 않는다.
  Future<void> clearMsgListener() async {
    await _delegate.clearMsgListener();
  }

  //#endregion

  //#region life cycle
  /// 단말앱이 활성 상태가 됨을 단말 라이브러리에게 알린다.
  Future<void> becomeActive() async {
    await _delegate.becomeActive();
  }

  /// 단말앱이 백그라운드 상태가 됨을 단말 라이브러리에게 알린다.
  Future<void> enterBackground() async {
    await _delegate.enterBackground();
  }

  /// 푸시 알림용 단말 토큰을 설정한다.
  ///
  /// - [deviceToken] : 단말 토큰
  Future<void> setDeviceToken(String deviceToken) async {
    await _delegate.setDeviceToken(deviceToken);
  }

  /// 설정한 앱 그룹을 라이브러리에게 알린다.
  ///
  /// Notification tracking을 이용하기 위해서는 반드시 컨테이너 앱(메인 앱)에서 `setAppGroup()`을 호출해야 한다.
  ///
  /// 1. 컨테이너 앱(메인 앱)에서 `setAppGroup()` 호출
  /// 2. Notification Service Extension에서 `enableNotificationTracking()` 호출
  ///
  /// iOS only.
  Future<void> setAppGroup(String appGroup) async {
    await _delegate.setAppGroup(appGroup);
  }

  /// 해당 단말 푸시 알림의 수신 여부 트래킹 및 실시간 모니터링을 활성화한다.
  ///
  /// - [data]: 커스텀 푸시 데이터 키-값 쌍
  /// - [appGroup]: iOS only.
  Future<void> enableNotificationTracking({
    required Map<String, dynamic> data,
    String? appGroup,
  }) async {
    await _delegate.enableNotificationTracking(data: data);
  }

  /// 단말앱을 등록한다.
  ///
  /// 이후 단말앱 등록 결과 `DeviceRegisterResultListener.onRegisterResult()` 콜백이 호출되고, 단말 등록 성공시 단말 등록 아이디가 발급된다.
  ///
  /// - [gateHost]: 래셔널아울 메시징 게이트로 국가별로 별도 존재 (범용 클라우드를 이용할 경우, `gate.rationalowl.com`)
  /// - [serviceId]: 단말앱이 등록할 모바일 서비스의 아이디
  /// - [deviceRegName]: 단말앱이 관리자 콘솔에서 표시될 이름 (앱 개발자 및 운영자의 관리자 콘솔 확인용)
  Future<void> registerDevice({
    required String gateHost,
    required String serviceId,
    String? deviceRegName,
  }) async {
    await _delegate.registerDevice(
      gateHost: gateHost,
      serviceId: serviceId,
      deviceRegName: deviceRegName,
    );
  }

  /// 단말앱을 등록 해제한다.
  ///
  /// 단말앱 등록 해제 결과 `DeviceRegisterResultListener.onUnregisterResult()` 콜백이 호출된다.
  ///
  /// - [serviceId]: 단말앱이 등록 해제할 모바일 서비스의 아이디
  Future<void> unregisterDevice({required String serviceId}) async {
    await _delegate.unregisterDevice(serviceId: serviceId);
  }

  /// 단말앱이 등록되어 있는지 확인한다.
  ///
  /// - [serviceId]: 서비스 아이디
  /// - [deviceRegId]: 단말 등록 아이디 (기존 `registerDevice()` API 호출 결과 발급받은 단말 등록 아이디)
  ///
  /// 단말앱 등록 여부를 반환한다.
  /// - `true`: 단말앱이 정상적으로 등록되어 있음
  /// - `false`: 단말앱이 아직 등록되지 않았거나, 단말앱 자동 삭제 모드 설정 후 3주 이상 폰을 꺼 놓은 상태로 방치하여 자동으로 등록 해제된 경우
  Future<bool> isDeviceAppRegister({
    required String serviceId,
    required String deviceRegId,
  }) async {
    return await _delegate.isDeviceAppRegister(
      serviceId: serviceId,
      deviceRegId: deviceRegId,
    );
  }

  /// 업스트림 메시지를 발신한다.
  ///
  /// 업스트림은 메시지는 큐잉을 지원하지 않는다.
  ///
  /// - [data]: 전달할 데이터 (JSON 또는 일반 문자열)
  /// - [serverRegId]: 데이터를 전달할 앱 서버의 등록 아이디
  ///
  /// 메시지 ID를 반환한다.
  Future<String?> sendUpstreamMsg({
    required String data,
    required String serverRegId,
  }) async {
    return await _delegate.sendUpstreamMsg(
      data: data,
      serverRegId: serverRegId,
    );
  }

  /// P2P 메시지를 발신한다.
  ///
  /// - [data]: 전달할 데이터 (JSON 또는 일반 문자열)
  /// - [destDevices]: 데이터를 전달할 단말앱들의 단말 등록 아이디 목록 (최대 2000대)
  /// - [supportMsgQ]: 단말앱이 비활성일 때 미전달 메시지의 큐잉 여부
  ///   - `true`: 미전달 메시지를 메시징 서버에서 큐잉 기간(기본 3일)동안 큐잉하고 있다가 단말이 활성 상태가 되면 미전달 메시지를 단말앱에 전달한다.
  ///   - `false`: 단말이 활성 상태가 되더라도 미전달 메시지를 단말앱에 전달하지 않음 (단말이 활성 상태에서 실시간 데이터 전달 용도로만 사용시)
  /// - [notiTitle]: 알림 용도로 메시지를 전달하는 경우, 단말앱이 비활성시 표시할 알림 제목
  /// - [notiBody]: 알림 용도로 메시지를 전달하는 경우, 단말앱이 비활성시 표시할 알림 내용
  /// [notiTitle]과 [notiBody]가 모두 `null`이면 단말앱이 비활성시 푸시 메시지를 발송하지 않는다.
  ///
  /// 메시지 ID를 반환한다.
  Future<String?> sendP2PMsg({
    required String data,
    required List<String> destDevices,
    bool supportMsgQ = true,
    String? notiTitle,
    String? notiBody,
  }) async {
    return await _delegate.sendP2PMsg(
      data: data,
      destDevices: destDevices,
      supportMsgQ: supportMsgQ,
      notiTitle: notiTitle,
      notiBody: notiBody,
    );
  }

  //#endregion
}
