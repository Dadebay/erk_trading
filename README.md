# Erk Trading

Flutter app for ERK Trading & Logistics. It opens the mobile site at [erktrading.com/indexmobile](https://erktrading.com/indexmobile/) in a WebView. Navigation stays on the official HTTPS host; if the main page fails to load, the app offers a retry action.

**[Get Erk Trading on Google Play](https://play.google.com/store/apps/details?id=com.gurbanov.erktrading)**

The Android application ID is `com.gurbanov.erktrading`, matching the published Play listing. The source currently declares version `2.2.5+17`. A newer Play upload must use a higher version code and the registered Play upload key. No iOS App Store listing has been verified for this repository.

## Requirements

- Flutter 3.47.8 / Dart 3.13.7 (the toolchain used for the checks below)
- Android SDK and JDK 17 for Android builds
- Xcode and CocoaPods for iOS builds

## Run and check

```sh
flutter pub get --enforce-lockfile
flutter run
dart format --output=none --set-exit-if-changed lib test
flutter analyze --no-pub
flutter test --no-pub
flutter build apk --release --no-pub
flutter build ios --no-codesign --release  # macOS only; not an installable IPA
```

The Android release build is **unsigned** unless a local `android/key.properties` points to the correct project keystore. See [`android/key.properties.example`](android/key.properties.example). Keep the real keystore and passwords outside Git. Never use a new key for an existing Play application without verifying its upload certificate in Play Console. An unsigned APK is a build check, not an installable release.

The GitHub Actions workflow runs dependency resolution, formatting, analysis, tests, and an unsigned Android release build. The app on Google Play is updated separately through Play Console; pushing this repository does not update the store listing.

## Platform behavior

- Android and iOS load only `https://erktrading.com/` pages inside the WebView. HTTP and IP-address fallback navigation is disabled.
- JavaScript is enabled because the mobile site needs it. A main-page network failure shows a retry action; subresource failures do not replace the page.
- Android back navigation goes to the previous WebView page, then exits the app when there is no history.

See [release readiness](docs/release-readiness.md) for signing and device-test limits before the next store submission.
