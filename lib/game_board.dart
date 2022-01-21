import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:scavenger_hunt_bingo/settings.dart';
import 'package:scavenger_hunt_bingo/widgets/ad_helper.dart';
import 'package:scavenger_hunt_bingo/widgets/banner_ad_widget.dart';
import 'package:scavenger_hunt_bingo/widgets/bingoBoard.dart';
import 'package:scavenger_hunt_bingo/widgets/bingo_banner.dart';
import 'package:scavenger_hunt_bingo/widgets/dialogs.dart';
import 'package:scavenger_hunt_bingo/widgets/size_config.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

const int maxFailedLoadAttempts = 3;

class GameBoard extends StatefulWidget {
  final String selectedBoard;
  final String selectedPattern;
  final bool withSound;

  const GameBoard({
    Key? key,
    required this.selectedBoard,
    required this.selectedPattern,
    required this.withSound,
  }) : super(key: key);

  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  late InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady = false;
  BannerAdContainer bannerAdContainer = BannerAdContainer();
  String boardDisplay = "";

  getBoardDisplay() {
    switch (widget.selectedBoard) {
      case "City Walk":
        boardDisplay = "City Walk";
        break;
      case "Trail Walk":
        boardDisplay = "Trail Walk";
        break;
      case "Stay Indoors":
        boardDisplay = "Stay Indoors";
        break;
      case "City with Images":
        boardDisplay = "City";
        break;
      case "Trail with Images":
        boardDisplay = "Trail";
        break;
      case "Indoors with Images":
        boardDisplay = "Indoors ";
        break;
      case "Grocery Store with Images":
        boardDisplay = "Grocery Store";
        break;
      case "Classroom with Images":
        boardDisplay = "Classroom";
        break;
      case "Restaurant with Images":
        boardDisplay = "Restaurant";
        break;
      case "Waiting Room":
        boardDisplay = "Waiting Room";
        break;
      default:
        boardDisplay = widget.selectedBoard;
    }
  }

  @override
  void initState() {
    super.initState();
    getBoardDisplay();
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

    _interstitialAd.dispose();
  }

  final screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: NewGradientAppBar(
        automaticallyImplyLeading: false,
        title: AutoSizeText(
          "Scavenger Bingo",
          style: TextStyle(
              color: Colors.yellow[50],
              fontFamily: 'CaveatBrush',
              fontSize: SizeConfig.blockSizeHorizontal * 10,
              letterSpacing: 2.0),
        ),
        gradient: LinearGradient(colors: [Colors.purple, Colors.blue]),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 5),
            child: IconButton(
              icon: Icon(
                Icons.share,
                size: SizeConfig.blockSizeHorizontal * 5,
              ),
              tooltip: 'Screenshot',
              onPressed: takeScreenShot,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(
                Icons.refresh,
                size: SizeConfig.blockSizeHorizontal * 5,
              ),
              tooltip: 'Restart Game',
              onPressed: () {
                result.clear();
                if (_isInterstitialAdReady) _interstitialAd.show();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SettingsPage(
                            withSound: widget.withSound,
                          )),
                );
              },
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.yellow[50],
        child: Screenshot(
          controller: screenshotController,
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
                                  fontSize: SizeConfig.blockSizeHorizontal * 6,
                                  color: Colors.blue),
                            ),
                            Text(
                              boardDisplay,
                              maxLines: 1,
                              style: TextStyle(
                                  fontFamily: 'CaveatBrush',
                                  fontSize: SizeConfig.blockSizeHorizontal * 6,
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
                                        fontSize:
                                            SizeConfig.blockSizeHorizontal * 6,
                                        color: Colors.blue),
                                  ),
                                ),
                                Text(
                                  widget.selectedPattern,
                                  style: TextStyle(
                                      fontFamily: 'CaveatBrush',
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 6,
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
                                  icon: Icon(
                                    Icons.help,
                                    color: Colors.purple,
                                    size: SizeConfig.blockSizeHorizontal * 5,
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
              bingoBoard(widget.selectedBoard, widget.selectedPattern,
                  widget.withSound, screenshotController),
            ]),
          ),
        ),
      ),
      // bottomNavigationBar: bannerAdContainer
    );
  }

  void takeScreenShot() async {
    final Size size = MediaQuery.of(context).size;
    final uint8List = await screenshotController.capture();
    String tempPath = (await getTemporaryDirectory()).path;
    File file = File('$tempPath/Bingo.png');
    await file.writeAsBytes(uint8List!);
    await Share.shareFiles(
      [file.path],
      text: "Shared from Scavenger Hunt Bingo!",
      sharePositionOrigin: Rect.fromLTWH(0, 0, size.width, size.height / 2),
    );
  }
}
