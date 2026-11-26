import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:label_flutter_plugin/label_flutter_plugin.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('getLabel before initialize throws not_initialized', (_) async {
    await LabelFlutterPlugin.reset();
    expect(
      LabelFlutterPlugin.getLabel(),
      throwsA(
        isA<LabelLicenseException>().having(
          (e) => e.reason,
          'reason',
          'not_initialized',
        ),
      ),
    );
  });

  testWidgets('bad credentials are rejected by the backend', (_) async {
    final license = await LabelFlutterPlugin.initialize(
      packageId: 'dummy',
      clientId: 'dummy',
      licenseKey: 'dummy',
    );
    expect(license.isValid, isFalse);
    expect(license.reason, 'invalid_credentials');
  });
}
