import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'label_flutter_plugin_method_channel.dart';
import 'src/license_result.dart';

abstract class LabelFlutterPluginPlatform extends PlatformInterface {
  /// Constructs a LabelFlutterPluginPlatform.
  LabelFlutterPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static LabelFlutterPluginPlatform _instance =
      MethodChannelLabelFlutterPlugin();

  /// The default instance of [LabelFlutterPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelLabelFlutterPlugin].
  static LabelFlutterPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [LabelFlutterPluginPlatform] when
  /// they register themselves.
  static set instance(LabelFlutterPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<LicenseResult> initialize({
    required String packageId,
    required String clientId,
    required String licenseKey,
  }) {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  Future<String> getLabel() {
    throw UnimplementedError('getLabel() has not been implemented.');
  }

  Future<bool> isLicensed() {
    throw UnimplementedError('isLicensed() has not been implemented.');
  }

  Future<void> reset() {
    throw UnimplementedError('reset() has not been implemented.');
  }
}
