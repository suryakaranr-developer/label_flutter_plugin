package com.suryakaranr.label_flutter_plugin

import com.suryakaranr.labelchannel.LabelMethodChannel
import io.flutter.embedding.engine.plugins.FlutterPlugin

/**
 * Connects this package's Dart MethodChannel to the Android MethodChannel
 * from label-android-sdk ([LabelMethodChannel]). That channel passes the
 * package ID, client ID and license key to the native Label SDK AAR and
 * returns its result to Dart.
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
