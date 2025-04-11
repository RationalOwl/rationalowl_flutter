/// 단말앱 등록 및 등록 해제 결과를 알려주는 콜백 인터페이스
abstract class DeviceRegisterResultListener {
  /// 단말앱 등록 결과 호출되는 콜백
  ///
  /// `MinervaManager.registerDevice()` 결과로서 호출된다.
  ///
  /// - [resultCode]
  ///   - `RESULT_OK`(1): 최초 `registerDevice()` 호출시
  ///   - `RESULT_SERVICE_ALREADY_REGISTERED`(-222): 정상
  /// - [resultMsg]: [resultCode]의 값에 대한 설명
  /// - [deviceRegId]: [resultCode]가 `RESULT_OK`(1) 또는 `RESULT_DEVICE_ALREADY_REGISTERED`(-122) 시 전달되는 단말앱 등록 아이디
  void onRegisterResult(int resultCode, String? resultMsg, String? deviceRegId);

  /// 단말앱 등록 해제 결과 호출되는 콜백
  ///
  /// `MinervaManager.unregisterDevice()` 결과로서 호출된다.
  ///
  /// - [resultCode]: 결과값 상수
  /// - [resultMsg]: [resultCode]의 값에 대한 설명
  void onUnregisterResult(int resultCode, String? resultMsg);
}
