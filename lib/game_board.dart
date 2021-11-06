import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:scavenger_hunt_bingo/settings.dart';
import 'package:scavenger_hunt_bingo/widgets/ad_helper.dart';
import 'package:scavenger_hunt_bingo/widgets/bingoBoard.dart';
import 'package:scavenger_hunt_bingo/widgets/bingo_banner.dart';
import 'package:scavenger_hunt_bingo/widgets/dialogs.dart';

const int maxFailedLoadAttempts = 3;

class GameBoard extends StatefulWidget {
  final String selectedBoard;
  final String selectedPattern;

  const GameBoard({
    Key? key,
    required this.selectedBoard,
    required this.selectedPattern,
  }) : super(key: key);

  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;
  late InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady = false;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
        // Change Banner Size According to Ur Need
        size: AdSize.banner,
        adUnitId: AdHelper.bannerAdUnitId,
        listener: BannerAdListener(onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        }, onAdFailedToLoad: (ad, LoadAdError error) {
          print("Failed to Load Banner Ad: ${error.message}");
          _isBannerAdReady = false;
          ad.dispose();
        }),
        request: AdRequest())
      ..load();
    //Interstitial Ads
    InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
          this._interstitialAd = ad;
          _isInterstitialAdReady = true;
        }, onAdFailedToLoad: (LoadAdError error) {
          print("Failed to Load Interstitial Ad ${error.message}");
        }));
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd.dispose();
    _interstitialAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: NewGradientAppBar(
          automaticallyImplyLeading: false,
          title: AutoSizeText(
            "Scavenger Bingo",
            style: TextStyle(
                color: Colors.yellow[50],
                fontFamily: 'CaveatBrush',
                fontSize: size.width,
                letterSpacing: 2.0),
          ),
          gradient: LinearGradient(colors: [
            // Colors.red,
            // Colors.orange,
            Colors.purple,
            // Colors.green,
            Colors.blue
          ]),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Restart Game',
              onPressed: () {
                result.clear();
                if (_isInterstitialAdReady) _interstitialAd.show();

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            ),
          ],
        ),
        body: Container(
          color: Colors.yellow[50],
          child: Center(
            child: Column(children: [
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 10, 8.0, 0),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Things found here->",
                              style: TextStyle(
                                  fontFamily: 'CaveatBrush',
                                  fontSize: size.width * 0.05,
                                  color: Colors.blue),
                            ),
                            AutoSizeText(
                              widget.selectedBoard,
                              minFontSize: 0,
                              stepGranularity: 0.1,
                              maxLines: 1,
                              style: TextStyle(
                                  fontFamily: 'CaveatBrush',
                                  fontSize: 16,
                                  color: Colors.purple),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Find this pattern ->",
                                    style: TextStyle(
                                        fontFamily: 'CaveatBrush',
                                        fontSize: size.width * 0.05,
                                        color: Colors.blue),
                                  ),
                                ),
                                Text(
                                  widget.selectedPattern,
                                  style: TextStyle(
                                      fontFamily: 'CaveatBrush',
                                      fontSize: size.width * 0.05,
                                      color: Colors.purple),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    await showDialog(
                                        context: context,
                                        builder: (_) => ImageDialog(
                                              selectedPattern:
                                                  widget.selectedPattern,
                                            ));
                                  },
                                  icon: const Icon(
                                    Icons.help,
                                    color: Colors.purple,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              bingoBanner(),
              bingoBoard(widget.selectedBoard, widget.selectedPattern),
            ]),
          ),
        ),
        bottomNavigationBar: (_isBannerAdReady)
            ? Container(
                height: _bannerAd.size.height.toDouble(),
                width: _bannerAd.size.width.toDouble(),
                child: AdWidget(ad: _bannerAd),
              )
            : Container(
                height: 50,
                color: Colors.yellow[50],
              ));
  }
}
