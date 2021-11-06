import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-1618980018345182/1905213342';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-1618980018345182/1761743112';
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-1618980018345182/4274573426";
    } else if (Platform.isIOS) {
      return "ca-app-pub-1618980018345182/6214341050";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}
