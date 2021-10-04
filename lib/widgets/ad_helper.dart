import 'dart:io';

class AdHelper {
  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/1033173712";
    } else if (Platform.isIOS) {
      return "ca-app-pub-1618980018345182/6214341050";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}
