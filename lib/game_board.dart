import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:scavenger_hunt_bingo/ad_state.dart';
import 'package:scavenger_hunt_bingo/main.dart';
import 'package:scavenger_hunt_bingo/widgets/ad_helper.dart';
import 'package:scavenger_hunt_bingo/widgets/bingoBoard.dart';
import 'package:scavenger_hunt_bingo/widgets/bingo_banner.dart';
import 'package:scavenger_hunt_bingo/widgets/dialogs.dart';

const int maxFailedLoadAttempts = 3;

class GameBoard extends StatefulWidget {
  final String selectedBoard;
  final String selectedPattern;
  const GameBoard(
      {Key? key, required this.selectedBoard, required this.selectedPattern})
      : super(key: key);

  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  late BannerAd banner;

  bool _isBannerAdReady = false;

  InterstitialAd? _interstitialAd;
  int _interstitialLoadAttempts = 0;

  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _interstitialLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _interstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_interstitialLoadAttempts <= maxFailedLoadAttempts) {
            _createInterstitialAd();
          }
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          _createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          _createInterstitialAd();
        },
      );
      _interstitialAd!.show();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _interstitialAd?.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _createInterstitialAd();
    final adState = Provider.of<AdState>(context);
    adState.initialization.then((status) {
      setState(() {
        banner = BannerAd(
            adUnitId: adState.bannerAdUnitId,
            size: AdSize.banner,
            request: AdRequest(),
            listener: adState.adListener)
          ..load();
      });
      _isBannerAdReady = true;
    });
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
              _showInterstitialAd();

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => IntroPage()),
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
                            "The card shows things found here ->",
                            style: TextStyle(
                                fontFamily: 'CaveatBrush',
                                fontSize: size.width * 0.05,
                                color: Colors.blue),
                          ),
                          Text(
                            widget.selectedBoard,
                            style: TextStyle(
                                fontFamily: 'CaveatBrush',
                                fontSize: size.width * 0.05,
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
                                            selectedPattern: selectedPattern,
                                          ));
                                },
                                icon: const Icon(
                                  Icons.help,
                                  color: Colors.purple,
                                ),
                              )
                            ],
                          ),
                          Row(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            bingoBanner(),
            Flexible(child: bingoBoard()),
            if (_isBannerAdReady)
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Container(
                  height: 50,
                  child: AdWidget(
                    ad: banner,
                  ),
                ),
              )
            else
              SizedBox(height: 50)
          ]),
        ),
      ),
    );
  }
}
