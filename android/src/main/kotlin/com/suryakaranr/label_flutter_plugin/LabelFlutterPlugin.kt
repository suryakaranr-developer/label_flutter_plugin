package com.suryakaranr.label_flutter_plugin

import android.content.Context
import com.suryakaranr.labelsdk.LabelLicenseException
import com.suryakaranr.labelsdk.LabelSdk
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/**
 * Android side of the `com.suryakaranr/label_flutter_plugin` MethodChannel.
 * Receives the package ID, client ID and license key from Dart and passes
 * them to the Label SDK AAR ([LabelSdk]).
 */
class LabelFlutterPlugin : FlutterPlugin, MethodCallHandler {

    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            METHOD_INITIALIZE -> initialize(call, result)
            METHOD_GET_LABEL -> getLabel(result)
            METHOD_IS_LICENSED -> result.success(LabelSdk.isLicensed)
            METHOD_RESET -> {
                LabelSdk.reset()
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    private fun initialize(call: MethodCall, result: Result) {
        val packageId = call.argument<String>(ARG_PACKAGE_ID)
        val clientId = call.argument<String>(ARG_CLIENT_ID)
        val licenseKey = call.argument<String>(ARG_LICENSE_KEY)
        if (packageId.isNullOrBlank() || clientId.isNullOrBlank() || licenseKey.isNullOrBlank()) {
            result.error(
                ERROR_INVALID_ARGUMENT,
                "packageId, clientId and licenseKey are required",
                null,
            )
            return
        }
        // LabelSdk delivers the callback on the main thread, as Flutter requires.
        LabelSdk.initialize(context, packageId, clientId, licenseKey) { license ->
            result.success(license.toMap())
        }
    }

    private fun getLabel(result: Result) {
        try {
            result.success(LabelSdk.getLabel())
        } catch (e: LabelLicenseException) {
            result.error(ERROR_LICENSE, e.reason, null)
        }
    }

    internal companion object {
        const val CHANNEL = "com.suryakaranr/label_flutter_plugin"

        const val METHOD_INITIALIZE = "initialize"
        const val METHOD_GET_LABEL = "getLabel"
        const val METHOD_IS_LICENSED = "isLicensed"
        const val METHOD_RESET = "reset"

        const val ARG_PACKAGE_ID = "packageId"
        const val ARG_CLIENT_ID = "clientId"
        const val ARG_LICENSE_KEY = "licenseKey"

        const val ERROR_LICENSE = "LICENSE_ERROR"
        const val ERROR_INVALID_ARGUMENT = "INVALID_ARGUMENT"
    }
}
