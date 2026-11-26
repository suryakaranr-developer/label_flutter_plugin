import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:label_flutter_plugin/label_flutter_plugin.dart';
import 'package:label_flutter_plugin/label_flutter_plugin_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final platform = MethodChannelLabelFlutterPlugin();
  const channel = MethodChannel(LabelChannel.name);
  final calls = <MethodCall>[];

  void mockHandler(Future<Object?>? Function(MethodCall call) handler) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) {
          calls.add(call);
          return handler(call);
        });
  }

  setUp(calls.clear);

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('initialize sends the credentials and parses a valid result', () async {
    mockHandler(
      (_) async => {
        'isValid': true,
        'reason': null,
        'clientName': 'Flyers',
        'clientId': 'c-1',
        'expiresAt': '2027-01-01T00:00:00Z',
      },
    );

    final result = await platform.initialize(
      packageId: 'pkg',
      clientId: 'c-1',
      licenseKey: 'key',
    );

    expect(calls.single.method, 'initialize');
    expect(calls.single.arguments, {
      'packageId': 'pkg',
      'clientId': 'c-1',
      'licenseKey': 'key',
    });
    expect(result.isValid, isTrue);
    expect(result.clientName, 'Flyers');
    expect(result.expiresAt, DateTime.utc(2027));
  });

  test('initialize parses an invalid result', () async {
    mockHandler((_) async => {'isValid': false, 'reason': 'revoked'});

    final result = await platform.initialize(
      packageId: 'pkg',
      clientId: 'c',
      licenseKey: 'k',
    );

    expect(result.isValid, isFalse);
    expect(result.reason, 'revoked');
  });

  test('getLabel returns the label', () async {
    mockHandler((_) async => 'My Name is Surya Karan R');
    expect(await platform.getLabel(), 'My Name is Surya Karan R');
  });

  test('getLabel maps LICENSE_ERROR to LabelLicenseException', () async {
    mockHandler(
      (_) async => throw PlatformException(
        code: 'LICENSE_ERROR',
        message: 'not_initialized',
      ),
    );

    expect(
      platform.getLabel(),
      throwsA(
        isA<LabelLicenseException>().having(
          (e) => e.reason,
          'reason',
          'not_initialized',
        ),
      ),
    );
  });

  test('isLicensed returns the platform value', () async {
    mockHandler((_) async => true);
    expect(await platform.isLicensed(), isTrue);
  });
}
