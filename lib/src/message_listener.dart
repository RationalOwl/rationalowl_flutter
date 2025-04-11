/// 앱 서버로부터의 다운스트림 메시지 수신시, 다른 단말앱으로부터의 P2P 메시지 수신시, 업스트림 메시지 발신 결과, P2P 메시지 발신 결과 호출되는 콜백 인터페이스
abstract class MessageListener {
  /// 실시간 데이터(다운스트림 메시지) 수신시 호출된다.
  ///
  /// - [msgList]: 수신한 메시지 목록 (JSON 배열 형식)
  ///   ```
  ///   [
  ///     {"sender":"your app server id", "serverTime":111222222111, "data":"plain text data or json text data"},
  ///     {"sender":"your app server id", "serverTime":111222222111, "data":"plain text data or json text data"}
  ///   ]
  ///   ```
  ///   - [sender]: 발신 앱 서버의 서버 등록 아이디
  ///   - [serverTime]: 메시지 발신 시간 (1970년 1월 1일 00:00 (UTC)로부터 경과한 밀리초)
  ///   - [data]: 일반 문자열 또는 JSON 형식 문자열
  void onDownstreamMsgReceived(List<Map<String, dynamic>> msgList) {}

  /// 실시간 데이터(P2P 메시지) 수신시 호출된다.
  ///
  /// - [msgList]: 수신한 메시지 목록 (JSON 배열 형식)
  ///   ```
  ///   [
  ///     {"sender":"sender id", "serverTime":111222222111, "data":"plain text data or json text data"},
  ///     {"sender":"sender id", "serverTime":111222222111, "data":"plain text data or json text data"}
  ///   ]
  ///   ```
  ///   - [sender]: 메시지 발신 단말앱의 단말앱 등록 아이디
  ///   - [serverTime]: 메시지 발신 시간 (1970년 1월 1일 00:00 (UTC)로부터 경과한 밀리초)
  ///   - [data]: 일반 문자열 또는 JSON 형식 문자열
  void onP2PMsgReceived(List<Map<String, dynamic>> msgList) {}

  /// 푸시 메시지 수신시 호출된다.
  ///
  /// 미전달 푸시 알림이 존재할 경우, 앱 실행 시 미전달 푸시 메시지 목록을 일괄 전달한다.
  ///
  /// 앱 실행시 발신한 푸시 메시지가 전달된다.
  ///
  /// - [msgList]: 수신한 메시지 목록 (JSON 배열 형식)
  ///   ```
  ///   [
  ///     {"sender":"your app server id", "serverTime":111222222111, "data":"plain text data or json text data"},
  ///     {"sender":"your app server id", "serverTime":111222222111, "data":"plain text data or json text data"}
  ///   ]
  ///   ```
  ///   - [sender]: 푸시 메시지 발신 API 호출한 앱 서버의 서버 등록 아이디
  ///   - [serverTime]: 메시지 발신 시간 (1970년 1월 1일 00:00 (UTC)로부터 경과한 밀리초)
  ///   - [data]: 일반 문자열 또는 JSON 형식 문자열
  void onPushMsgReceived(List<Map<String, dynamic>> msgList) {}

  /// `MinervaManager.sendUpstreamMsg()` 결과로서, 메시지 발신 결과 정상적으로 발신되었는지 체크하는 용도의 콜백이다.
  ///
  /// 많은 메시지가 수발신되는 상황에서 본 인터페이스 구현은 성능 저하를 야기할 수 있다.
  ///
  /// - [resultCode]: 메시지 발신 결과 상수
  /// - [resultMsg]: [resultCode]에 대한 설명
  /// - [msgId]: 메시지 ID
  void onSendUpstreamMsgResult(
    int resultCode,
    String? resultMsg,
    String? msgId,
  ) {}

  /// `MinervaManager.sendP2PMsg()` 결과로서, 메시지 발신 결과 정상적으로 발신되었는지 체크하는 용도의 콜백이다.
  ///
  /// 많은 메시지가 수발신되는 상황에서 본 인터페이스 구현은 성능 저하를 야기할 수 있다.
  ///
  /// - [resultCode]: 메시지 발신 결과 상수
  /// - [resultMsg]: [resultCode]에 대한 설명
  /// - [msgId]: 메시지 ID
  void onSendP2PMsgResult(int resultCode, String? resultMsg, String? msgId) {}
}
