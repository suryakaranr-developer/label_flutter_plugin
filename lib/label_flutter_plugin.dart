import 'label_flutter_plugin_platform_interface.dart';
import 'src/license_result.dart';

export 'src/license_result.dart';

/// Flutter entry point of the Label SDK.
///
/// All calls go over a MethodChannel to the Android plugin, which calls the
/// Label SDK AAR. The AAR checks the license against Supabase and holds the
/// label logic.
///
/// ```dart
/// final license = await LabelFlutterPlugin.initialize(
///   packageId: '...',
///   clientId: '...',
///   licenseKey: '...',
/// );
/// if (license.isValid) {
///   final label = await LabelFlutterPlugin.getLabel();
/// }
/// ```
abstract final class LabelFlutterPlugin {
  static LabelFlutterPluginPlatform get _platform =>
      LabelFlutterPluginPlatform.instance;

  /// Validates [packageId], [clientId] and [licenseKey] against the license
  /// backend. Never throws for an invalid license: check
  /// [LicenseResult.isValid] and [LicenseResult.reason].
  static Future<LicenseResult> initialize({
    required String packageId,
    required String clientId,
    required String licenseKey,
  }) => _platform.initialize(
    packageId: packageId,
    clientId: clientId,
    licenseKey: licenseKey,
  );

  /// Returns the label.
  ///
  /// Throws [LabelLicenseException] if [initialize] has not been called or
  /// the license is not valid.
  static Future<String> getLabel() => _platform.getLabel();

  /// `true` once [initialize] has returned a valid license.
  static Future<bool> isLicensed() => _platform.isLicensed();

  /// Forgets the current license.
  static Future<void> reset() => _platform.reset();
}
