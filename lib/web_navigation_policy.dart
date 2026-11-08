const erkTradingHomeUrl = 'https://erktrading.com/indexmobile/';

bool isTrustedErkTradingUrl(String rawUrl) {
  final uri = Uri.tryParse(rawUrl);
  return uri != null &&
      uri.scheme == 'https' &&
      uri.host == 'erktrading.com' &&
      !uri.hasPort &&
      uri.userInfo.isEmpty;
}
