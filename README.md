# Flutter 래셔널아울 플러그인

[![pub package](https://img.shields.io/pub/v/rationalowl_flutter.svg)](https://pub.dev/packages/rationalowl_flutter)

[래셔널아울 API](https://www.rationalowl.com)를 사용하기 위한 Flutter 플러그인입니다.


## 개발환경

- 플러터 IOS, 안드로이드 맥북에서 동일한 개발환경으로 진행하는 것을 권장
- 래셔널아울 Flutter 라이브러리 개발환경은 아래와 같다(2025년 4월 10일 기준)
- macos: Sequoia 15.4, Android studio: MeerKat 2024.3.1 patch1, Xcode: 16.3 Flutter SDK: 3.29.2

## 라이브러리 배포
- 본 개발환경으로 만들어지는 래셔널아울 flutter라이브러리명은 rationalowl_flutter 이다.
- pubspec.yaml 파일에 라이브러리 버전을 명시하여 flutter pub publish로 라이브러리를 pub.dev 레파지토리에 배포한다.

## 사용 방법

플러그인을 사용하려면, `rationalowl_flutter`를 [pubspec.yaml 파일의 종속 항목으로 추가](https://flutter.dev/docs/development/platform-integration/platform-channels)합니다.


## 시작하기

* 클라우드 메시징(FCM)과 Apple 푸시 알림 서비스(APNs)를 래셔널아울 서비스와 연동합니다.
  * [FCM 설정 가이드](https://github.com/RationalOwl/rationalowl-guide/blob/master/device-app/fcm-setting/README.md)
  * [.p8 인증 키를 통한 APNs 설정 가이드 (권장)](https://github.com/RationalOwl/rationalowl-guide/tree/master/device-app/ios-apns-p8)
  * [.p12 인증 키를 통한 APNs 설정 가이드](https://github.com/RationalOwl/rationalowl-guide/tree/master/device-app/ios-apns-p12)


### Android 클라이언트 설정

1. [래셔널아울 Android 라이브러리 파일](https://github.com/RationalOwl/rationalowl_flutter/raw/main/example/android/app/libs/rationalowl-android-1.4.1.aar)(`rationalowl-android-1.4.1.aar`)을 다운로드합니다.

2. `android/app` 디렉토리에 `libs` 디렉토리를 생성하고, `rationalowl-android-1.4.1.aar` 파일을 복사합니다.

![android1](https://github.com/RationalOwl/rationalowl_flutter/raw/main/images/android1.png)

3. **모듈 수준 Grade 파일**(`android/app/build.gradle`)에 래셔널아울 Android 라이브러리의 종속 항목을 추가합니다.

```groovy
dependencies {
    implementation fileTree(include: ['*.jar'], dir: 'libs')
    implementation files('libs/rationalowl-android-1.4.1.aar')
}
```

4. 백그라운드 메시지를 수신하려면 [firebase_messaging](https://pub.dev/packages/firebase_messaging)을 사용합니다.


### iOS 클라이언트 설정

1. Xcode 프로젝트 작업 공간 파일(`ios/Runner.xcworkspace`)을 엽니다.

2. [래셔널아울 iOS 라이브러리](https://github.com/RationalOwl/rationalowl_flutter/tree/main/example/ios)(`RationalOwl.framework`)를 다운로드합니다.

3. `RationalOwl.framework` 디렉토리를 `Runner` 프로젝트로 드래그 앤 드롭합니다.

4. `Copy items if needed` 체크 상자를 선택하고, `Finish`를 클릭합니다.

![ios1](https://github.com/RationalOwl/rationalowl_flutter/raw/main/images/ios1.png)

5. `Runner` 프로젝트를 선택하고, `Runner` 타겟을 선택합니다.

6. `Frameworks, Libraries, and Embedded Content` 영역에서, `+` 버튼을 클릭합니다.

7. `Add Files...` 메뉴를 클릭하고, `RationalOwl.framework` 디렉토리를 선택합니다.

![ios2](https://github.com/RationalOwl/rationalowl_flutter/raw/main/images/ios2.png)

8. `Signing & Capabilities` 탭을 선택하고, `+ Capability` 버튼을 클릭합니다.

9. `Push Notifications`와 `Background Modes` 기능을 추가합니다.

10. `Background Modes` 기능에서, `Background fetch`와 `Remote notifications` 모드를 활성화합니다.

![ios3](https://github.com/RationalOwl/rationalowl_flutter/raw/main/images/ios3.png)

11. `Build Phases` 탭을 선택하고, `Link Binary With Libraries` 영역을 펼칩니다.

12. `+` 버튼을 클릭합니다.

13. `UserNotifications.framework`를 선택하고, `Add`를 클릭합니다.

![ios4](https://github.com/RationalOwl/rationalowl_flutter/raw/main/images/ios4.png)

14. Xcode 상단 메뉴에서, **File > New > Target...** 메뉴를 선택합니다.

15. `Notification Service Extension` 템플릿을 선택하고, `Next`를 클릭합니다.

![ios5](https://github.com/RationalOwl/rationalowl_flutter/raw/main/images/ios5.png)

16. `Product Name`을 입력하고, `Finish`를 클릭합니다.

![ios6](https://github.com/RationalOwl/rationalowl_flutter/raw/main/images/ios6.png)


### 단말앱 등록

단말앱이 래셔널아울 API를 통해 실시간 데이터 통신을 하기 위해, 먼저 단말앱을 고객 모바일 서비스에 등록합니다.
- 등록된 단말앱들이 해당 모바일 서비스에 등록된 모든 단말과 실시간 메시지를 수/발신할 수 있습니다.
- 관리자 콘솔의 `서비스 > 단말현황`에서 단말 앱 등록 및 등록 해제 과정을 실시간 모니터링할 수 있습니다.

#### 단말앱 등록 결과 리스너 등록

단말앱 등록 및 등록 해제 결과를 알려주는 콜백 인터페이스인 [`DeviceRegisterResultListener`](https://pub.dev/documentation/rationalowl_flutter/latest/rationalowl_flutter/DeviceRegisterResultListener-class.html)를 먼저 등록합니다.

```dart
MinervaManager minMgr = MinervaManager.getInstance();
await minMgr.setRegisterResultListener(this);
```

#### 단말앱 등록 요청

[`MinervaManager.registerDevice()`](https://pub.dev/documentation/rationalowl_flutter/latest/rationalowl_flutter/MinervaManager/registerDevice.html)를 통해 단말앱을 원하는 서비스의 단말 앱으로 등록 요청합니다.

API 호출 후 단말앱 등록 결과 발급받은 단말 등록 아이디를 반드시 저장 및 관리해야 함을 유의합니다.

단말앱 등록 API는 단말앱 설치 후 1회만 호출하면 됩니다.

![reg](https://github.com/RationalOwl/rationalowl-guide/raw/master/device-app/android/img/reg.png)

```dart
MinervaManager mgr = MinervaManager.getInstance();

if (Platform.isAndroid) {
  String? fcmToken = await FirebaseMessaging.instance.getToken();

  if (fcmToken == null) {
    log('FCM Token 조회 실패');
    return;
  }

  await mgr.setDeviceToken(fcmToken);
}

await mgr.setRegisterResultListener(this);
mgr.registerDevice(gateHost: '211.239.150.113', serviceId: 'SVCf5db348a-069b-4a70-b5b0-05468a732241', deviceRegName: 'RationalOwl Flutter Example');
```

#### 단말앱 등록 결과 콜백 처리

단말앱 등록 결과는 [`DeviceRegisterResultListener.onRegisterResult()`](https://pub.dev/documentation/rationalowl_flutter/latest/rationalowl_flutter/DeviceRegisterResultListener/onRegisterResult.html) 콜백을 통해 처리합니다.

단말앱 등록이 성공하면, 단말앱은 발급받은 단말 등록 아이디를 저장 및 관리해야 합니다.

```dart
@override
void onRegisterResult(int resultCode, String? resultMsg, String? deviceRegId) {
  switch (resultCode) {
    case 1:   // RESULT_OK
      log('단말앱 등록 성공: $deviceRegId');
      break;
    case -122:  // RESULT_DEVICE_ALREADY_REGISTERED
      log('이미 등록된 단말앱: $deviceRegId');
      break;
    default:
      log('단말앱 등록 오류: $resultMsg ($resultCode)');
      break;
  }
}
```


### 단말앱 등록 해제

고객 서비스 내에서 사용하지 않는 단말앱을 등록 해제합니다.

래셔널아울 관리자 콘솔은 단말앱 등록 해제 결과에 대해 실시간 모니터링을 제공합니다.

#### 단말앱 등록 해제 요청

[`MinervaManager.unregisterDevice()`](https://pub.dev/documentation/rationalowl_flutter/latest/rationalowl_flutter/MinervaManager/unregisterDevice.html)를 통해 단말앱 등록 해제를 요청합니다.

```dart
MinervaManager minMgr = MinervaManager.getInstance();
minMgr.unregisterDevice(serviceId: _serviceId);
```

#### 단말앱 등록 해제 결과

단말앱 등록 해제 결과는 [`DeviceRegisterResultListener.onUnregisterResult()`](https://pub.dev/documentation/rationalowl_flutter/latest/rationalowl_flutter/DeviceRegisterResultListener/onUnregisterResult.html) 콜백을 통해 처리합니다.

```dart
@override
void onUnregisterResult(int resultCode, String? resultMsg) {
  if (resultCode == 1) {  // RESULT_OK
    _showSnackBar('단말앱 등록 해제 성공');
  } else {
    _showSnackBar('단말앱 등록 해제 오류: $resultMsg ($resultCode)');
  }
}
```


### 메시지 리스너 등록

단말앱은 앱 서버로 업스트림 메시지를 발신하거나, 다른 단말앱들에 P2P 메시지를 발신할 수 있습니다.
또한 앱 서버로부터 다운스트림 메시지를 수신하거나, 다른 단말앱으로부터 P2P 메시지 수신할 수 있습니다.

이러한 메시지 발신 결과와 메시지 수신을 처리하기 위해서는 메시지 리스너를 등록해야 합니다.

메시지 리스너는 메시지 수발신을 처리할 클래스를 [`MinervaManager.setMsgListener()`](https://pub.dev/documentation/rationalowl_flutter/latest/rationalowl_flutter/MinervaManager/setMsgListener.html)로 지정합니다.

```dart
MinervaManager minMgr = MinervaManager.getInstance();
minMgr.setMsgListener(RoMessageListener());
```

메시지 리스너를 해제하는 코드는 다음과 같습니다.

```dart
MinervaManager minMgr = MinervaManager.getInstance();
minMgr.clearMsgListener();
```


### 업스트림 메시지 발신

래셔널아울 서비스는 다수의 앱 서버를 지원하며, 단말앱은 특정 앱 서버에게 업스트림 메시지를 발신할 수 있습니다.

래셔널아울에서 지원하는 업스트림 메시지의 특성은 다음과 같습니다.
- 지원하는 데이터 포맷은 `String`으로, 일반 문자열이나 JSON 형식 등 고객 서비스 특성에 맞게 설정할 수 있습니다.
- 업스트림은 메시지 큐잉을 지원하지 않습니다.
- 래셔널아울 콘솔은 데이터 전달 현황에 대해 실시간 모니터링을 제공합니다.

![upstream](https://github.com/RationalOwl/rationalowl-guide/raw/master/device-app/android/img/upstream.png)

#### 업스트림 메시지 발신

[`MinervaManager.sendUpstreamMsg()`](https://pub.dev/documentation/rationalowl_flutter/latest/rationalowl_flutter/MinervaManager/sendUpstreamMsg.html)를 통해 업스트림 메시지를 발신합니다.

```dart
MinervaManager minMgr = MinervaManager.getInstance();
minMgr.sendUpstreamMsg(data: 'Upstream Message', serverRegId: 'SVR74083a2a-48c6-46ea-b558-cedef12d10fa');
```

#### 업스트림 메시지 발신 결과

메시지 리스너로 등록한 [`MessageListener.onSendUpstreamMsgResult()`](https://pub.dev/documentation/rationalowl_flutter/latest/rationalowl_flutter/MessageListener/onSendUpstreamMsgResult.html) 콜백이 호출됩니다.

![upstream_callback](https://github.com/RationalOwl/rationalowl-guide/raw/master/device-app/android/img/upstream_callback.png)

```dart
@override
void onSendUpstreamMsgResult(int resultCode, String? resultMsg, String? msgId) {
  log('onSendUpstreamMsgResult(resultCode: $resultCode, resultMsg: $resultMsg, msgId: $msgId)');
}
```


### P2P 메시지 발신

래셔널아울 서비스는 P2P 메시지를 지원하며, 평균 0.1초 미만의 실시간 데이터 전달을 보장합니다.

래셔널아울에서 지원하는 P2P 메시지의 특성은 다음과 같습니다.
- 한 대 이상의 단말앱에 메시지를 발신할 수 있습니다.
- 한 번에 보낼 수 있는 최대 대상 단말 수는 2000대입니다.
- 지원하는 데이터 포맷은 `String`으로, 일반 일반 문자열이나 JSON 형식 등 고객 서비스 특성에 맞게 설정할 수 있습니다.
- 메시지 전달 대상 단말앱이 네트워크에 연결되지 않은 경우, 큐잉 후 단말이 네트워크 접속시 전달합니다.
- 기본 큐잉 기간은 3일이며, 엔터프라이즈 에디션에서는 최대 30일까지 설정 가능합니다.
- 큐잉 기능을 이용 여부는 단말앱 라이브러리에서 제공하는 P2P API를 통해 설정할 수 있습니다.
- P2P API를 통해 대상 단말앱이 네트워크에 연결되지 않은 경우, 전달 데이터 외에 알림 제목과 알림 내용을 별도로 지정할 수 있습니다.
- 래셔널아울 콘솔은 데이터 전달 현황에 대해 실시간 모니터링을 제공합니다.

#### P2P 메시지 발신

[`MinervaManager.sendP2PMsg()`](https://pub.dev/documentation/rationalowl_flutter/latest/rationalowl_flutter/MinervaManager/sendP2PMsg.html)를 통해 P2P 메시지를 발신합니다.

![p2p](https://github.com/RationalOwl/rationalowl-guide/raw/master/device-app/ios-swift/img/p2p.png)

```dart
MinervaManager minMgr = MinervaManager.getInstance();

String message = jsonEncode({
  'mId': DateTime.now().millisecondsSinceEpoch.toString(),
  'title': title,
  'body': body,
});

minMgr.sendP2PMsg(
  data: message,
  destDevices: [recipientDeviceRegId],
  notiTitle: 'P2P Message',
  notiBody: 'P2P Message',
);
```

#### P2P 메시지 발신 결과

메시지 리스너로 등록한 [`MessageListener.onSendP2PMsgResult()`](https://pub.dev/documentation/rationalowl_flutter/latest/rationalowl_flutter/MessageListener/onSendP2PMsgResult.html) 콜백이 호출됩니다.

![p2p_callback](https://github.com/RationalOwl/rationalowl-guide/raw/master/device-app/ios-swift/img/p2p_callback.png)

```dart
@override
void onSendP2PMsgResult(int resultCode, String? resultMsg, String? msgId) {
  log('onSendP2PMsgResult(resultCode: $resultCode, resultMsg: $resultMsg, msgId: $msgId)');
}
```


### 메시지 수신

앱 서버로부터 다운스트림 메시지 수신 시 또는 다른 단말앱으로부터 P2P 메시지 수신 시, 콜백이 호출되어 단말앱이 이를 처리할 수 있습니다.

#### 다운스트림 메시지 수신

앱 서버에서 발신하는 멀티캐스트, 브로드캐스트, 그룹 메시지를 단말앱이 수신시 [`MessageListener.onPushMsgReceived()`](https://pub.dev/documentation/rationalowl_flutter/latest/rationalowl_flutter/MessageListener/onPushMsgReceived.html) 콜백이 호출됩니다.

![down_rcv](https://github.com/RationalOwl/rationalowl-guide/raw/master/device-app/ios-swift/img/down_rcv.png)

```dart
@override
void onPushMsgReceived(List<Map<String, dynamic>> msgList) {
  log('onPushMsgReceived(msgList: $msgList)');

  if (msgList.isNotEmpty) {
    final latestMessage = Map<String, dynamic>.from(msgList[0]['data']);
    showNotification(latestMessage);
  }
}
```

#### P2P 메시지 수신

다른 단말앱으로부터 P2P 메시지 수신시 [`MessageListener.onP2PMsgReceived()`](https://pub.dev/documentation/rationalowl_flutter/latest/rationalowl_flutter/MessageListener/onP2PMsgReceived.html) 콜백이 호출됩니다.

![p2p_rcv](https://github.com/RationalOwl/rationalowl-guide/raw/master/device-app/ios-swift/img/p2p_rcv.png)

```dart
@override
void onP2PMsgReceived(List<Map<String, dynamic>> msgList) {
  log('onP2PMsgReceived(msgList: $msgList)');

  if (msgList.isNotEmpty) {
    final latestMessage = Map<String, dynamic>.from(msgList[0]['data']);
    showNotification(latestMessage);
  }
}
```


## 사용 예시

```dart
const iOSAppGroup = 'group.com.rationalowl.flutterexample';

Future<void> _initialize() async {
  if (Platform.isAndroid) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    FirebaseMessaging.onBackgroundMessage(handleMessage);
  }

  await initializeNotification();

  final MinervaManager minMgr = MinervaManager.getInstance();

  if (Platform.isIOS) {
    await minMgr.setAppGroup(iOSAppGroup);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initialize();

  runApp(const Application());
}

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<StatefulWidget> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> with WidgetsBindingObserver {
  late final MinervaAppLifecycleObserver _observer;

  @override
  void initState() {
    super.initState();

    if (Platform.isIOS) {
      _observer = MinervaAppLifecycleObserver();
      WidgetsBinding.instance.addObserver(_observer);
    } else {
      FirebaseMessaging.instance.onTokenRefresh.listen(handleTokenRefresh);
    }

    final MinervaManager minMgr = MinervaManager.getInstance();
    minMgr.setMsgListener(RoMessageListener());
  }

  @override
  void dispose() {
    if (Platform.isIOS) {
      WidgetsBinding.instance.removeObserver(_observer);
    }

    final MinervaManager minMgr = MinervaManager.getInstance();
    minMgr.clearMsgListener();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: MainPage(),
        ),
      ),
    );
  }
}
```


### 포그라운드 메시지

Android, iOS 애플리케이션이 포그라운드에 있는 동안 메시지를 처리하려면, [`MessageListener`](https://pub.dev/documentation/rationalowl_flutter/latest/rationalowl_flutter/MessageListener-class.html) 클래스를 구현합니다.

```dart
class RoMessageListener implements MessageListener {
  @override
  void onDownstreamMsgReceived(List<Map<String, dynamic>> msgList) {}

  @override
  void onP2PMsgReceived(List<Map<String, dynamic>> msgList) {
    if (msgList.isNotEmpty) {
      final latestMessage = Map<String, dynamic>.from(msgList[0]['data']);
      showNotification(latestMessage);
    }
  }

  @override
  void onPushMsgReceived(List<Map<String, dynamic>> msgList) {
    if (msgList.isNotEmpty) {
      final latestMessage = Map<String, dynamic>.from(msgList[0]['data']);
      showNotification(latestMessage);
    }
  }

  @override
  void onSendUpstreamMsgResult(int resultCode, String? resultMsg, String? msgId) {}

  @override
  void onSendP2PMsgResult(int resultCode, String? resultMsg, String? msgId) {}
}
```

구현한 리스너 클래스를 [`MinervaManager.setMsgListener()`](https://pub.dev/documentation/rationalowl_flutter/latest/rationalowl_flutter/MinervaManager/setMsgListener.html)로 등록합니다.

```dart
MinervaManager minMgr = MinervaManager.getInstance();
minMgr.setMsgListener(RoMessageListener());
```


### 백그라운드 메시지

#### Android

**Android** 애플리케이션이 백그라운드에 있는 동안 메시지를 처리하려면, `FirebaseMessaging.onBackgroundMessage()`를 호출하여 핸들러를 등록합니다.

```dart
@pragma('vm:entry-point')
Future<void> handleMessage(RemoteMessage message) async {
  final Map<String, dynamic> data = message.data;

  final MinervaManager minMgr = MinervaManager.getInstance();
  minMgr.enableNotificationTracking(data: data);

  if (!data.containsKey('silent')) {
    showNotification(data);
  }
}
```

```dart
FirebaseMessaging.onBackgroundMessage(handleMessage);
```

#### iOS

**iOS** 애플리케이션이 백그라운드에 있는 동안 메시지를 처리하려면, Swift 코드 `ios/{Product Name}/NotificationService.swift`에서 `UNNotificationServiceExtension` 클래스를 구현합니다.

```swift
class NotificationService: UNNotificationServiceExtension {
    private static let appGroup = "group.com.rationalowl.flutterexample"

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest,
                             withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            let userInfo = bestAttemptContent.userInfo

            let minMgr = MinervaManager.getInstance()!
            minMgr.enableNotificationTracking(userInfo, appGroup: Self.appGroup)

            if userInfo["notiTitle"] != nil {
                bestAttemptContent.title = userInfo["notiTitle"] as! String
            }
            if userInfo["notiBody"] != nil {
                bestAttemptContent.body = userInfo["notiBody"] as! String
            }

            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}
```


### 등록 토큰 구독

#### Android

**Android** 애플리케이션에서 토큰이 업데이트될 때마다 알림을 받으려면, `FirebaseMessaging` 클래스의 `onTokenRefresh` 스트림을 구독합니다.

```dart
Future<void> handleTokenRefresh(String token) async {
  final MinervaManager minMgr = MinervaManager.getInstance();
  minMgr.setDeviceToken(token);
}
```

```dart
FirebaseMessaging.instance.onTokenRefresh.listen(handleTokenRefresh);
```


[example](https://github.com/RationalOwl/rationalowl_flutter/tree/main/example) 디렉토리에서 전체 샘플 앱을 확인할 수 있습니다.
