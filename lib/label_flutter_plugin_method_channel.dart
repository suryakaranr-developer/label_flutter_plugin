import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'label_flutter_plugin_platform_interface.dart';
import 'src/license_result.dart';

/// Names shared with the Android side (`LabelFlutterPlugin.kt`).
abstract final class LabelChannel {
  static const String name = 'com.suryakaranr/label_flutter_plugin';

  static const String initialize = 'initialize';
  static const String getLabel = 'getLabel';
  static const String isLicensed = 'isLicensed';
  static const String reset = 'reset';

  static const String argPackageId = 'packageId';
  static const String argClientId = 'clientId';
  static const String argLicenseKey = 'licenseKey';

  /// Error code Android returns when the license is missing or invalid.
  static const String licenseError = 'LICENSE_ERROR';
}

/// An implementation of [LabelFlutterPluginPlatform] that uses method channels.
class MethodChannelLabelFlutterPlugin extends LabelFlutterPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel(LabelChannel.name);

  @override
  Future<LicenseResult> initialize({
    required String packageId,
    required String clientId,
    required String licenseKey,
  }) async {
    final map = await methodChannel.invokeMapMethod<Object?, Object?>(
      LabelChannel.initialize,
      <String, String>{
        LabelChannel.argPackageId: packageId,
        LabelChannel.argClientId: clientId,
        LabelChannel.argLicenseKey: licenseKey,
      },
    );
    if (map == null) {
      return const LicenseResult(isValid: false, reason: 'server_error');
    }
    return LicenseResult.fromMap(map);
  }

  @override
  Future<String> getLabel() async {
    try {
      final label = await methodChannel.invokeMethod<String>(
        LabelChannel.getLabel,
      );
      return label!;
    } on PlatformException catch (e) {
      if (e.code == LabelChannel.licenseError) {
        throw LabelLicenseException(e.message ?? 'invalid_credentials');
      }
      rethrow;
    }
  }

  @override
  Future<bool> isLicensed() async =>
      await methodChannel.invokeMethod<bool>(LabelChannel.isLicensed) ?? false;

  @override
  Future<void> reset() => methodChannel.invokeMethod<void>(LabelChannel.reset);
}
