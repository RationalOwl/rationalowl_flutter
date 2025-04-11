import Flutter
import UIKit

import RationalOwl

let channelName = "plugins.rationalowl.com/rationalowl_flutter"

public class FlutterRationalOwlPlugin: NSObject, FlutterPlugin {
    private static var channel: FlutterMethodChannel!

    private weak var originalNotificationCenterDelegate: UNUserNotificationCenterDelegate?

    private struct RespondsTo {
        var willPresentNotification: Bool = false
        var didReceiveNotificationResponse: Bool = false
        var openSettingsFor: Bool = false
    }

    private var originalNotificationCenterDelegateRespondsTo = RespondsTo()

    public static func register(with registrar: FlutterPluginRegistrar) {
        channel = FlutterMethodChannel(name: channelName, binaryMessenger: registrar.messenger())

        let instance = FlutterRationalOwlPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)
    }

    override private init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(application_onDidFinishLaunchingNotification(_:)), name: UIApplication.didFinishLaunchingNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        var value: Any? = nil

        switch call.method {
        case "MinervaManager#setRegisterResultListener":
            setRegisterResultListener()
        case "MinervaManager#clearRegisterResultListener":
            clearRegisterResultListener()
        case "MinervaManager#setMsgListener":
            setMsgListener()
        case "MinervaManager#clearMsgListener":
            clearMsgListener()
        case "MinervaManager#becomeActive":
            becomeActive()
        case "MinervaManager#enterBackground":
            enterBackground()
        case "MinervaManager#setDeviceToken":
            setDeviceToken(call.arguments as! [String: Any])
        case "MinervaManager#setAppGroup":
            setAppGroup(call.arguments as! [String: Any])
        case "MinervaManager#enableNotificationTracking":
            enableNotificationTracking(call.arguments as! [String: Any])
        case "MinervaManager#registerDevice":
            registerDevice(call.arguments as! [String: Any])
        case "MinervaManager#unregisterDevice":
            unregisterDevice(call.arguments as! [String: Any])
        case "MinervaManager#isDeviceAppRegister":
            value = isDeviceAppRegister(call.arguments as! [String: Any])
        case "MinervaManager#sendUpstreamMsg":
            value = sendUpstreamMsg(call.arguments as! [String: Any])
        case "MinervaManager#sendP2PMsg":
            value = sendP2PMsg(call.arguments as! [String: Any])
        default:
            result(FlutterMethodNotImplemented)
            return
        }

        result(value)
    }

    private func setRegisterResultListener() {
        let minMgr = MinervaManager.getInstance()!
        minMgr.setDeviceRegisterResultDelegate(self)
    }

    private func clearRegisterResultListener() {
        let minMgr = MinervaManager.getInstance()!
        minMgr.clearDeviceRegisterResultDelegate()
    }

    private func setMsgListener() {
        let minMgr = MinervaManager.getInstance()!
        minMgr.setMessageDelegate(self)
    }

    private func clearMsgListener() {
        let minMgr = MinervaManager.getInstance()!
        minMgr.clearMessageDelegate()
    }

    private func becomeActive() {
        let minMgr = MinervaManager.getInstance()!
        minMgr.becomeActive()
    }

    private func enterBackground() {
        let minMgr = MinervaManager.getInstance()!
        minMgr.enterBackground()
    }

    private func enableNotificationTracking(_ arguments: [String: Any]) {
        let minMgr = MinervaManager.getInstance()!
        let data = arguments["data"] as! [AnyHashable: Any]
        let appGroup = arguments["appGroup"] as! String
        minMgr.enableNotificationTracking(data, appGroup: appGroup)
    }

    private func setDeviceToken(_ arguments: [String: Any]) {
        let minMgr = MinervaManager.getInstance()!
        let deviceToken = arguments["deviceToken"] as! String
        minMgr.setDeviceToken(deviceToken)
    }

    private func setAppGroup(_ arguments: [String: Any]) {
        let minMgr = MinervaManager.getInstance()!
        let appGroup = arguments["appGroup"] as! String
        minMgr.setAppGroup(appGroup)
    }

    private func registerDevice(_ arguments: [String: Any]) {
        let minMgr = MinervaManager.getInstance()!
        let gateHost = arguments["gateHost"] as! String
        let serviceId = arguments["serviceId"] as! String
        let deviceRegName = arguments["deviceRegName"] as! String
        minMgr.registerDevice(gateHost, serviceId: serviceId, deviceRegName: deviceRegName)
    }

    private func unregisterDevice(_ arguments: [String: Any]) {
        let minMgr = MinervaManager.getInstance()!
        let serviceId = arguments["serviceId"] as! String
        minMgr.unregisterDevice(serviceId)
    }

    private func isDeviceAppRegister(_ arguments: [String: Any]) -> Bool {
        let minMgr = MinervaManager.getInstance()!
        let serviceId = arguments["serviceId"] as! String
        let deviceRegId = arguments["deviceRegId"] as! String
        return minMgr.isDeviceAppRegister(serviceId, deviceRegId: deviceRegId)
    }

    private func sendUpstreamMsg(_ arguments: [String: Any]) -> String? {
        let minMgr = MinervaManager.getInstance()!
        let data = arguments["data"] as! String
        let serverRegId = arguments["serverRegId"] as! String
        return minMgr.sendUpstreamMsg(data, serverRegId: serverRegId)
    }

    private func sendP2PMsg(_ arguments: [String: Any]) -> String? {
        let minMgr = MinervaManager.getInstance()!
        let data = arguments["data"] as! String
        let destDevices = arguments["destDevices"] as! [String]
        let supportMsgQ = arguments["supportMsgQ"] as! Bool
        let notiTitle = arguments["notiTitle"] as? String
        let notiBody = arguments["notiBody"] as? String
        return minMgr.sendP2PMsg(data, devices: destDevices, supportMsgQ: supportMsgQ, notiTitle: notiTitle, notiBody: notiBody)
    }

    @objc func application_onDidFinishLaunchingNotification(_ notification: Notification) {
        var shouldReplaceDelegate = true
        let notificationCenter = UNUserNotificationCenter.current()

        if notificationCenter.delegate != nil {
            if notificationCenter.delegate is FlutterAppLifeCycleProvider {
                shouldReplaceDelegate = false
            }

            if shouldReplaceDelegate {
                originalNotificationCenterDelegate = notificationCenter.delegate
                originalNotificationCenterDelegateRespondsTo.openSettingsFor = originalNotificationCenterDelegate!.responds(to: #selector(UNUserNotificationCenterDelegate.userNotificationCenter(_:openSettingsFor:)))
                originalNotificationCenterDelegateRespondsTo.willPresentNotification = originalNotificationCenterDelegate!.responds(to: #selector(UNUserNotificationCenterDelegate.userNotificationCenter(_:willPresent:withCompletionHandler:)))
                originalNotificationCenterDelegateRespondsTo.didReceiveNotificationResponse = originalNotificationCenterDelegate!.responds(to: #selector(UNUserNotificationCenterDelegate.userNotificationCenter(_:didReceive:withCompletionHandler:)))
            }
        }

        if shouldReplaceDelegate {
            notificationCenter.delegate = self
        }
    }
}

extension FlutterRationalOwlPlugin: UIApplicationDelegate {
    public func applicationDidBecomeActive(_ application: UIApplication) {
        let minMgr = MinervaManager.getInstance()!
        minMgr.becomeActive()
    }

    public func applicationWillResignActive(_ application: UIApplication) {
        let minMgr = MinervaManager.getInstance()!
        minMgr.enterBackground()
    }
}

extension FlutterRationalOwlPlugin: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void)
    {
        let userInfo = response.notification.request.content.userInfo
        let minMgr = MinervaManager.getInstance()!
        minMgr.receivedApns(userInfo)

        if originalNotificationCenterDelegate != nil && originalNotificationCenterDelegateRespondsTo.didReceiveNotificationResponse {
            originalNotificationCenterDelegate!.userNotificationCenter!(center, didReceive: response, withCompletionHandler: completionHandler)
        } else {
            completionHandler()
        }
    }

    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        if originalNotificationCenterDelegate != nil && originalNotificationCenterDelegateRespondsTo.willPresentNotification {
            originalNotificationCenterDelegate!.userNotificationCenter!(center, willPresent: notification, withCompletionHandler: completionHandler)
        } else {
            completionHandler([])
        }
    }

    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       openSettingsFor notification: UNNotification?)
    {
        if originalNotificationCenterDelegate != nil && originalNotificationCenterDelegateRespondsTo.openSettingsFor {
            originalNotificationCenterDelegate!.userNotificationCenter!(center, openSettingsFor: notification)
        }
    }
}

extension FlutterRationalOwlPlugin: DeviceRegisterResultDelegate {
    public func onRegisterResult(_ resultCode: Int32, resultMsg: String?, deviceRegId: String?) {
        var args: [String: Any] = [
            "resultCode": resultCode
        ]

        if resultMsg != nil {
            args["resultMsg"] = resultMsg
        }

        if deviceRegId != nil {
            args["deviceRegId"] = deviceRegId
        }

        DispatchQueue.main.async {
            Self.channel.invokeMethod("DeviceRegisterResultListener#onRegisterResult", arguments: args)
        }
    }

    public func onUnregisterResult(_ resultCode: Int32, resultMsg: String?) {
        var args: [String: Any] = [
            "resultCode": resultCode
        ]

        if resultMsg != nil {
            args["resultMsg"] = resultMsg
        }

        DispatchQueue.main.async {
            Self.channel.invokeMethod(
                "DeviceRegisterResultListener#onUnregisterResult", arguments: args
            )
        }
    }
}

extension FlutterRationalOwlPlugin: MessageDelegate {
    public func onDownstreamMsgRecieved(_ msgList: [Any]!) {
        DispatchQueue.main.async {
            Self.channel.invokeMethod("MessageListener#onDownstreamMsgRecieved", arguments: msgList)
        }
    }

    public func onP2PMsgRecieved(_ msgList: [Any]!) {
        let decodedMsgList = msgList.map { msg in
            guard var msgDict = msg as? [String: Any] else { return msg }

            guard let dataString = msgDict["data"] as? String,
                  let data = dataString.data(using: .utf8) else { return msgDict }

            do {
                msgDict["data"] = try JSONSerialization.jsonObject(with: data)
            } catch {}

            return msgDict
        }

        DispatchQueue.main.async {
            Self.channel.invokeMethod("MessageListener#onP2PMsgRecieved", arguments: decodedMsgList)
        }
    }

    public func onPushMsgRecieved(_ msgSize: Int32, msgList: [Any]!, alarmIdx: Int32) {
        DispatchQueue.main.async {
            Self.channel.invokeMethod("MessageListener#onPushMsgRecieved", arguments: msgList)
        }
    }

    public func onUpstreamMsgResult(_ resultCode: Int32, resultMsg: String?, msgId: String?) {
        var args: [String: Any] = [
            "resultCode": resultCode
        ]

        if resultMsg != nil {
            args["resultMsg"] = resultMsg
        }

        if msgId != nil {
            args["msgId"] = msgId
        }

        DispatchQueue.main.async {
            Self.channel.invokeMethod("MessageListener#onSendUpstreamMsgResult", arguments: args)
        }
    }

    public func onP2PMsgResult(_ resultCode: Int32, resultMsg: String?, msgId: String?) {
        var args: [String: Any] = [
            "resultCode": resultCode
        ]

        if resultMsg != nil {
            args["resultMsg"] = resultMsg
        }

        if msgId != nil {
            args["msgId"] = msgId
        }

        DispatchQueue.main.async {
            Self.channel.invokeMethod("MessageListener#onSendP2PMsgResult", arguments: args)
        }
    }
}
