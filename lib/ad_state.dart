import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState {
  Future<InitializationStatus> initialization;

  AdState(this.initialization);

  String get bannerAdUnitId => Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  BannerAdListener get adListener => _adListener;

  BannerAdListener _adListener = BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => print('Ad loaded: ${ad.adUnitId}.'),
    onAdClosed: (Ad ad) => print('Ad closed: ${ad.adUnitId}.'),
    onAdFailedToLoad: (ad, error) {
      // Dispose the ad here to free resources.
      ad.dispose();
      print('Ad failed to load: ${ad.adUnitId}, $error.');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.

    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => print('Ad impression.'),
  );
}
