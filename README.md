# label_flutter_plugin

Flutter package for the Label SDK. The Dart API sends the **package ID, client ID
and license key** over this package's MethodChannel to the Android MethodChannel
from `label-android-sdk`, which passes them to the native Label SDK AAR. The AAR
checks the license against Supabase and, once valid, returns the label. The result
comes back through both MethodChannels to Dart and on to the app.

```
Flutter app ──Dart API──▶ MethodChannel "com.suryakaranr/label_flutter_plugin"
                                  │
                                  ▼
         labelchannel AAR: LabelMethodChannel  (Android MethodChannel)
                                  │
                                  ▼
         labelsdk AAR: LabelSdk  (native)
                   ├─ license check → Supabase validate_package RPC
                   └─ label logic

LabelFlutterPlugin.kt only registers LabelMethodChannel with the Flutter engine.
Both AARs (1.2.0) are in android/libs/maven.
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

Handled on Android by `LabelMethodChannel` in the labelchannel AAR. Channel `com.suryakaranr/label_flutter_plugin`:

| Method | Arguments | Result |
|---|---|---|
| `initialize` | `{packageId, clientId, licenseKey}` | `{isValid, reason, clientName, clientId, expiresAt}`; error `INVALID_ARGUMENT` if any is missing |
| `getLabel` | none | `String`; error `LICENSE_ERROR` with the reason as message |
| `isLicensed` | none | `bool` |
| `reset` | none | `null` |

## Updating the bundled AARs

Both AARs are kept in `android/libs/maven` as a folder Maven repository. From the
`label-android-sdk` repository:

```bash
./gradlew :labelsdk:publishReleasePublicationToLocalFolderRepository :labelchannel:publishReleasePublicationToLocalFolderRepository -PlabelRepoDir=../label_flutter_plugin/android/libs/maven
```

For a new version, also update the `labelchannel` dependency in `android/build.gradle.kts`.

## Tests

```bash
flutter test
```

```bash
cd example && flutter test integration_test
```

The integration test runs on a device or emulator and calls the real license backend.
