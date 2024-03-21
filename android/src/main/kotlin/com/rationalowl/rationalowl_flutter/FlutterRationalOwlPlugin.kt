package com.rationalowl.rationalowl_flutter

import com.rationalowl.minerva.client.android.DeviceRegisterResultListener
import com.rationalowl.minerva.client.android.MessageListener
import com.rationalowl.minerva.client.android.MinervaManager
import com.rationalowl.minerva.client.android.util.Logger
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONObject
import java.lang.reflect.Field
import kotlin.collections.ArrayList

private const val CHANNEL_NAME = "plugins.rationalowl.com/rationalowl_flutter"

class FlutterRationalOwlPlugin : FlutterPlugin, MethodCallHandler, DeviceRegisterResultListener,
    MessageListener {
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, CHANNEL_NAME)
        channel.setMethodCallHandler(this)

        MinervaManager.init(binding.applicationContext)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        var value: Any? = null

        when (call.method) {
            "MinervaManager#setRegisterResultListener" -> setRegisterResultListener()
            "MinervaManager#clearRegisterResultListener" -> clearRegisterResultListener()
            "MinervaManager#setMsgListener" -> setMsgListener()
            "MinervaManager#clearMsgListener" -> clearMsgListener()
            "MinervaManager#becomeActive" -> becomeActive()
            "MinervaManager#enterBackground" -> enterBackground()
            "MinervaManager#setDeviceToken" -> setDeviceToken(call.arguments())
            "MinervaManager#enableNotificationTracking" -> enableNotificationTracking(call.arguments())
            "MinervaManager#registerDevice" -> registerDevice(call.arguments())
            "MinervaManager#unregisterDevice" -> unregisterDevice(call.arguments())
            "MinervaManager#isDeviceAppRegister" -> value = isDeviceAppRegister(call.arguments())
            "MinervaManager#sendUpstreamMsg" -> value = sendUpstreamMsg(call.arguments())
            "MinervaManager#sendP2PMsg" -> value = sendP2PMsg(call.arguments())
            else -> {
                result.notImplemented()
                return
            }
        }

        result.success(value)
    }

    private fun setRegisterResultListener() {
        val minMgr = MinervaManager.getInstance()
        minMgr.setRegisterResultListener(this)
    }

    private fun clearRegisterResultListener() {
        val minMgr = MinervaManager.getInstance()
        minMgr.clearRegisterResultListener()
    }

    private fun setMsgListener() {
        val minMgr = MinervaManager.getInstance()
        minMgr.setMsgListener(this)
    }

    private fun clearMsgListener() {
        val minMgr = MinervaManager.getInstance()
        minMgr.clearMsgListener()
    }

    private fun becomeActive() {
        val minMgr = MinervaManager.getInstance()
        minMgr.becomeActive()
    }

    private fun enterBackground() {
        val minMgr = MinervaManager.getInstance()
        minMgr.enterBackground()
    }

    private fun enableNotificationTracking(arguments: Map<String, Any>?) {
        try {
            println("enableNotificationTracking started")
            val minMgr = MinervaManager.getInstance()
            val data = arguments?.get("data") as Map<String, String>
            minMgr.enableNotificationTracking(data)
            println("enableNotificationTracking done")
        } catch (e: Exception) {
            println(e);
        }
    }

    private fun setDeviceToken(arguments: Map<String, Any>?) {
        val minMgr = MinervaManager.getInstance()
        val deviceToken = arguments?.get("deviceToken") as String
        minMgr.setDeviceToken(deviceToken)
    }

    private fun registerDevice(arguments: Map<String, Any>?) {
        val minMgr = MinervaManager.getInstance()
        val gateHost = arguments?.get("gateHost") as String
        val serviceId = arguments["serviceId"] as String
        val deviceRegName = arguments["deviceRegName"] as String
        minMgr.registerDevice(gateHost, serviceId, deviceRegName)
    }

    private fun unregisterDevice(arguments: Map<String, Any>?) {
        val minMgr = MinervaManager.getInstance()
        val serviceId = arguments?.get("serviceId") as String
        minMgr.unregisterDevice(serviceId)
    }

    private fun isDeviceAppRegister(arguments: Map<String, Any>?): Boolean {
        val minMgr = MinervaManager.getInstance()
        val serviceId = arguments?.get("serviceId") as String
        val deviceRegId = arguments["deviceRegId"] as String
        return minMgr.isDeviceAppRegister(serviceId, deviceRegId)
    }

    private fun sendUpstreamMsg(arguments: Map<String, Any>?): String? {
        val minMgr = MinervaManager.getInstance()
        val data = arguments?.get("data") as String
        val serverRegId = arguments["serverRegId"] as String
        return minMgr.sendUpstreamMsg(data, serverRegId)
    }

    private fun sendP2PMsg(arguments: Map<String, Any>?): String? {
        val minMgr = MinervaManager.getInstance()
        val data = arguments?.get("data") as String
        val destDevices = arguments.get("destDevices") as ArrayList<String>
        val supportMsgQ = arguments["supportMsgQ"] as Boolean
        val notiTitle = arguments["notiTitle"] as String?
        val notiBody = arguments["notiBody"] as String?
        return minMgr.sendP2PMsg(data, destDevices, supportMsgQ, notiTitle, notiBody)
    }

    public override fun onRegisterResult(
        resultCode: Int,
        resultMsg: String?,
        deviceRegId: String?
    ) {
        channel.invokeMethod(
            "DeviceRegisterResultListener#onRegisterResult", mapOf(
                "resultCode" to resultCode,
                "resultMsg" to resultMsg,
                "deviceRegId" to deviceRegId
            )
        )
    }

    public override fun onUnregisterResult(resultCode: Int, resultMsg: String?) {
        channel.invokeMethod(
            "DeviceRegisterResultListener#onUnregisterResult", mapOf(
                "resultCode" to resultCode,
                "resultMsg" to resultMsg,
            )
        )
    }

    private fun decodeMsgList(msgList: ArrayList<JSONObject>): List<Map<String, Any?>> {
        return msgList.map {
            val data = it.getString("data")
            it.put("data", JSONObject(data).toMap())
            it.toMap()
        }
    }

    public override fun onDownstreamMsgRecieved(msgList: ArrayList<JSONObject>) {
        channel.invokeMethod("MessageListener#onDownstreamMsgRecieved", decodeMsgList(msgList))
    }

    public override fun onP2PMsgRecieved(msgList: ArrayList<JSONObject>) {
        channel.invokeMethod("MessageListener#onP2PMsgRecieved", decodeMsgList(msgList))
    }

    public override fun onPushMsgRecieved(msgList: ArrayList<JSONObject>) {
        channel.invokeMethod("MessageListener#onPushMsgRecieved", decodeMsgList(msgList))
    }

    public override fun onSendUpstreamMsgResult(
        resultCode: Int,
        resultMsg: String?,
        msgId: String?
    ) {
        channel.invokeMethod(
            "MessageListener#onSendUpstreamMsgResult", mapOf(
                "resultCode" to resultCode,
                "resultMsg" to resultMsg,
                "msgId" to msgId
            )
        )
    }

    public override fun onSendP2PMsgResult(
        resultCode: Int,
        resultMsg: String?,
        msgId: String?
    ) {
        channel.invokeMethod(
            "MessageListener#onSendP2PMsgResult", mapOf(
                "resultCode" to resultCode,
                "resultMsg" to resultMsg,
                "msgId" to msgId
            )
        )
    }

    private fun JSONObject.toMap(): Map<String, Any?> {
        val map = HashMap<String, Any?>()
        keys().forEach { key -> map[key] = this[key] }

        return map
    }
}
