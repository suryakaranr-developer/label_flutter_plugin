import 'package:flutter_test/flutter_test.dart';
import 'package:label_flutter_plugin/label_flutter_plugin.dart';
import 'package:label_flutter_plugin/label_flutter_plugin_method_channel.dart';
import 'package:label_flutter_plugin/label_flutter_plugin_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class FakeLabelPlatform
    with MockPlatformInterfaceMixin
    implements LabelFlutterPluginPlatform {
  Map<String, String>? lastInit;

  @override
  Future<LicenseResult> initialize({
    required String packageId,
    required String clientId,
    required String licenseKey,
  }) async {
    lastInit = {
      'packageId': packageId,
      'clientId': clientId,
      'licenseKey': licenseKey,
    };
    return const LicenseResult(isValid: true, clientName: 'Test');
  }

  @override
  Future<String> getLabel() async => 'My Name is Surya Karan R';

  @override
  Future<bool> isLicensed() async => true;

  @override
  Future<void> reset() async {}
}

void main() {
  final initialPlatform = LabelFlutterPluginPlatform.instance;

  test('$MethodChannelLabelFlutterPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelLabelFlutterPlugin>());
  });

  test(
    'passes the credentials to the platform and returns the label',
    () async {
      final fake = FakeLabelPlatform();
      LabelFlutterPluginPlatform.instance = fake;

      final license = await LabelFlutterPlugin.initialize(
        packageId: 'pkg',
        clientId: 'client',
        licenseKey: 'key',
      );

      expect(license.isValid, isTrue);
      expect(fake.lastInit, {
        'packageId': 'pkg',
        'clientId': 'client',
        'licenseKey': 'key',
      });
      expect(await LabelFlutterPlugin.getLabel(), 'My Name is Surya Karan R');
    },
  );
}
