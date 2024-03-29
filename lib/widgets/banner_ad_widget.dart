import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:scavenger_hunt_bingo/main.dart';
import 'package:scavenger_hunt_bingo/utils/ad_helper.dart';

class BannerAdContainer extends StatefulWidget {
  const BannerAdContainer({Key? key}) : super(key: key);

  @override
  _BannerAdContainerState createState() => _BannerAdContainerState();
}

class _BannerAdContainerState extends State<BannerAdContainer> {
  late BannerAd _bottomBannerAd;

  bool _isBottomBannerAdLoaded = false;

  void _createBottomBannerAd() {
    _bottomBannerAd = BannerAd(
      adUnitId:
          useTestAds ? AdHelper.testBannerAdUnitID : AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBottomBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint("ad widget error: $error");
          ad.dispose();
        },
      ),
    );
    _bottomBannerAd.load();
  }

  @override
  void initState() {
    super.initState();
    _createBottomBannerAd();
  }

  @override
  void dispose() {
    super.dispose();
    _bottomBannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.yellow[50],
      ), // border: Border(top: BorderSide(color: Colors.blue))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Advertisement",
              style: TextStyle(letterSpacing: 2, color: Colors.purple)),
          Container(
            child: _isBottomBannerAdLoaded
                ? SizedBox(
                    height: _bottomBannerAd.size.height.toDouble(),
                    width: _bottomBannerAd.size.width.toDouble(),
                    child: AdWidget(ad: _bottomBannerAd),
                  )
                : Container(
                    color: Colors.yellow[50],
                    height: 60,
                  ),
          ),
        ],
      ),
    );
  }
}
