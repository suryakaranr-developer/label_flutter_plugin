package com.suryakaranr.label_flutter_plugin

import com.suryakaranr.labelsdk.flutter.LabelMethodChannel
import io.flutter.embedding.engine.plugins.FlutterPlugin

/**
 * Registers the Label SDK's Android MethodChannel ([LabelMethodChannel],
 * inside the AAR). The Dart side of this package sends the package ID,
 * client ID and license key over that channel; the AAR handles every call.
 */
class LabelFlutterPlugin : FlutterPlugin {

    private var channel: LabelMethodChannel? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = LabelMethodChannel.register(binding.binaryMessenger, binding.applicationContext)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel?.dispose()
        channel = null
    }
}
