import 'package:erk_trading/web_navigation_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('allows the official HTTPS site and its pages', () {
    expect(isTrustedErkTradingUrl(erkTradingHomeUrl), isTrue);
    expect(
      isTrustedErkTradingUrl('https://erktrading.com/indexmobile/contact/'),
      isTrue,
    );
  });

  test('rejects insecure and lookalike navigation', () {
    for (final url in [
      'http://194.67.67.38/',
      'http://erktrading.com/indexmobile/',
      'https://erktrading.com.evil.example/',
      'https://erktrading.com@evil.example/',
      'https://erktrading.com:8443/',
    ]) {
      expect(isTrustedErkTradingUrl(url), isFalse, reason: url);
    }
  });
}
