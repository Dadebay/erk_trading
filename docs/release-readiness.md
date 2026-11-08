# Erk Trading release readiness

Checked on 8 November 2026. The official Android listing is [Erk Trading on Google Play](https://play.google.com/store/apps/details?id=com.gurbanov.erktrading), and the source package ID is `com.gurbanov.erktrading`.

## Verified locally

- The mobile site at `https://erktrading.com/indexmobile/` responded over HTTPS.
- Flutter analysis passed, and two navigation-policy tests passed.
- Android `assembleRelease` and `flutter build apk --release --no-pub` completed with JDK 17 and Gradle 9.1.0. The output was **unsigned**, as intended without a verified upload key. Android build metadata reports version name `2.2.5`, version code `17`, and the correct package ID. The generated Gradle wrapper is committed so clean checkouts can build.
- iOS release compilation passed with code signing disabled; this does not verify provisioning, installation, or App Store submission.
- The insecure HTTP/IP fallback and unrestricted cleartext settings were removed from Android, iOS, and WebView navigation. A failed main-page load now offers retry.
- Two unused packages and an unused duplicate `MainActivity` were removed.

## Before the next store upload

- Confirm the Play Console upload-certificate SHA-256 and locate the matching keystore. A candidate PKCS12 key exists in local secure storage, but its existing `key.properties` points to a nonexistent file and names a different alias. Its certificate SHA-256 is `63:F3:30:A0:58:C8:D3:F4:B3:7B:3B:A8:5A:B9:1C:2C:93:C3:93:20:0E:FD:F7:D4:66:51:09:BA:BF:7F:6B:80`. Do not use it until Play Console confirms a match. Keep credentials outside Git.
- Increase the version code above `17` for a new Google Play build. Build and verify the signed AAB from the exact release commit, then test installation and upgrade on a physical Android device.
- Test main-page loading, retry, navigation, external links, and Android back behavior on a device. Confirm the website has no required HTTP-only resources. Check iOS behavior and signing separately before an iOS release.
- Review GitHub Actions results and store policy declarations before submitting an update. The repository push alone does not publish a new Play version.
