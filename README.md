# label_flutter_plugin

Flutter package for the Label SDK. The Dart API sends the **package ID, client ID
and license key** over a MethodChannel to the Android MethodChannel handler that
lives in the Label SDK AAR. The AAR checks the license against Supabase and, once
valid, returns the label.

```
Flutter app ──Dart API──▶ MethodChannel "com.suryakaranr/label_flutter_plugin"
                                  │
                                  ▼
                 Label SDK AAR (com.suryakaranr:labelsdk)
                   ├─ LabelMethodChannel  (Android MethodChannel handler)
                   ├─ LabelSdk
                   │    ├─ license check → Supabase validate_package RPC
                   │    └─ label logic

LabelFlutterPlugin.kt only registers LabelMethodChannel with the Flutter engine.
```

Platforms: Android (minSdk 24).

## Usage

```dart
import 'package:label_flutter_plugin/label_flutter_plugin.dart';

final license = await LabelFlutterPlugin.initialize(
  packageId: '<package id>',
  clientId: '<client id>',
  licenseKey: '<license key>',
);

if (license.isValid) {
  final label = await LabelFlutterPlugin.getLabel(); // "My Name is Surya Karan R"
} else {
  // license.reason: invalid_credentials, revoked, expired, app_not_allowed,
  // not_configured, network_error, server_error
}
```

| Method | Returns |
|---|---|
| `initialize(packageId:, clientId:, licenseKey:)` | `LicenseResult` (never throws for an invalid license) |
| `getLabel()` | `String`; throws `LabelLicenseException` if not licensed |
| `isLicensed()` | `bool` |
| `reset()` | forgets the license |

## MethodChannel contract

Handled on Android by `LabelMethodChannel` in the AAR. Channel `com.suryakaranr/label_flutter_plugin`:

| Method | Arguments | Result |
|---|---|---|
| `initialize` | `{packageId, clientId, licenseKey}` | `{isValid, reason, clientName, clientId, expiresAt}`; error `INVALID_ARGUMENT` if any is missing |
| `getLabel` | none | `String`; error `LICENSE_ERROR` with the reason as message |
| `isLicensed` | none | `bool` |
| `reset` | none | `null` |

## Updating the bundled AAR

The AAR is kept in `android/libs/maven` as a folder Maven repository. From the
`label-android-sdk` repository (bump `version` in `labelsdk/build.gradle.kts`
and the dependency in `android/build.gradle.kts` for a new version):

```bash
./gradlew :labelsdk:publishReleasePublicationToLocalFolderRepository -PlabelRepoDir=../label_flutter_plugin/android/libs/maven
```

## Tests

```bash
flutter test
```

```bash
cd example && flutter test integration_test
```

The integration test runs on a device or emulator and calls the real license backend.
