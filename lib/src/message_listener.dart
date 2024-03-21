/// 앱서버로부터의 다운스트림 메시지 수신시, 다른 단말앱으로부터의 P2P메시지 수신시, 업스트림 메시지 발신결과, P2P 메시지 발신결과 호출되는 콜백 인터페이스
abstract class MessageListener {
  /// 실시간 데이터(다운스트림 메시지) 수신시 호출된다.
  ///
  /// - [msgs] : 수신한 메시지 목록이다. JSON 배열 포맷이다.
  ///
  ///   format :
  ///   ```
  ///   [
  ///     {"sender":"your app server id", "serverTime":111222222111, "data":"plain text data or json text data"},
  ///     {"sender":"your app server id", "serverTime":111222222111, "data":"plain text data or json text data"}
  ///   ]
  ///   ```
  ///   - [sender] : 발신 앱서버의 서버 등록 아이디
  ///   - [serverTime] : 메시지 발신 시간으로 1970년 1월 1일 0:0:0 UTC로부터 경과한 시간(밀리초 단위)
  ///   - [data] : 일반 스트링 또는 JSON 포맷 스트링
  void onDownstreamMsgReceived(List<Map<String, dynamic>> msgList) {}

  /// 실시간 데이터(P2P 메시지) 수신시 호출된다.
  ///
  /// - [msgs] : 수신한 메시지 목록이다. JSON 배열 포맷이다.
  ///
  ///   format :
  ///   ```
  ///   [
  ///     {"sender":"sender id", "serverTime":111222222111, "data":"plain text data or json text data"},
  ///     {"sender":"sender id", "serverTime":111222222111, "data":"plain text data or json text data"}
  ///   ]
  ///   ```
  ///   - [sender] : 메시지 발신 단말앱의 단말앱 등록 아이디
  ///   - [serverTime] : 메시지 발신 시간으로 1970년 1월 1일 0:0:0 UTC로부터 경과한 시간(밀리초 단위)
  ///   - [data] : 일반 스트링 또는 JSON 포맷 스트링
  void onP2PMsgReceived(List<Map<String, dynamic>> msgList) {}

  /// 푸시 메시지 수신시 호출된다.
  ///
  /// 미전달 푸시 알림 존재시 앱실행 시 미전달 푸시메시지 목록을 일괄 전달한다.
  ///
  /// 앱실행시 발신한 푸시 메시지가 전달된다.
  ///
  /// - [msgs] : 수신한 메시지 목록이다. JSON 배열 포맷이다.
  ///
  ///   format :
  ///   ```
  ///   [
  ///     {"sender":"your app server id", "serverTime":111222222111, "data":"plain text data or json text data"},
  ///     {"sender":"your app server id", "serverTime":111222222111, "data":"plain text data or json text data"}
  ///   ]
  ///   ```
  ///   - [sender] : 푸시메시지 발신 API 호출한 앱서버의 서버 등록 아이디
  ///   - [serverTime] : 메시지 발신 시간으로 1970년 1월 1일 0:0:0 UTC로부터 경과한 시간(밀리초 단위)
  ///   - [data] : 일반 스트링 또는 JSON 포맷 스트링
  void onPushMsgReceived(List<Map<String, dynamic>> msgList) {}

  /// `MinervaManager`의 `sendUpstreamMsg()` API 호출결과 호출된다.
  ///
  /// 메시지 발신 결과 정상적으로 발신되었는지 체크하는 용도의 콜백 인터페이스다.
  ///
  /// 많은 메시지가 수발신되는 상황에서 본 인터페이스 구현은 성능저하를 야기할 수 있다.
  ///
  /// - [resultCode] : 메시지 발신 결과로 `Result` 클래스에 정의된 결과값 상수
  /// - [resultMsg] : [resultCode]의 값에 대한 의미
  /// - [msgId] : message id
  void onSendUpstreamMsgResult(int resultCode, String? resultMsg, String? msgId) {}

  /// `MinervaManager`의 `sendP2PMsg()` API 호출결과 호출된다.
  ///
  /// 메시지 발신 결과 정상적으로 발신되었는지 체크하는 용도의 콜백 인터페이스다.
  ///
  /// 많은 메시지가 수발신되는 상황에서 본 인터페이스 구현은 성능저하를 야기할 수 있다.
  ///
  /// - [resultCode] : 메시지 발신 결과로 `Result` 클래스에 정의된 결과값 상수
  /// - [resultMsg] : [resultCode]의 값에 대한 의미
  /// - [msgId] : message id
  void onSendP2PMsgResult(int resultCode, String? resultMsg, String? msgId) {}
}
