/// 단말앱 등록 및 등록 해제 결과를 알려주는 콜백 인터페이스
abstract class DeviceRegisterResultListener {
  /// 단말앱 등록 결과 호출되는 콜백
  ///
  /// `MinervaManager`의 `registerDevice()` 결과 호출된다.
  ///
  /// - [resultCode] : `Result.RESULT_OK` : 최초 `registerAppServer()`시 반환.
  /// 이후 정상적일 경우 `Result.RESULT_SERVER_REGNAME_ALREADY_REGISTERED`이 반환된다.
  /// - [resultMsg] : [resultCode]의 값에 대한 의미
  /// - [deviceRegId] : [resultCode]가 `Result.RESULT_OK` 또는 `Result.RESULT_DEVICE_ALREADY_REGISTERED` 시 전달되는 단말앱 등록 아이디
  void onRegisterResult(int resultCode, String? resultMsg, String? deviceRegId);

  /// 단말앱 등록 해제 결과 호출되는 콜백
  ///
  /// `MinervaManager`의 `unregisterDevice()` 결과 호출된다.
  ///
  /// - [resultCode] : `Result` 클래스에 정의된 결과값 상수
  /// - [resultMsg] : [resultCode]의 값에 대한 의미
  void onUnregisterResult(int resultCode, String? resultMsg);
}
