import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:scavenger_hunt_bingo/providers/settings_provider.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

const int maxFailedLoadAttempts = 3;

class GameBoard extends StatefulWidget {
  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  late InterstitialAd _interstitialAd;
  bool _isInterstitialAdReady = false;
  BannerAdContainer bannerAdContainer = BannerAdContainer();
  String boardDisplay = "";
  var settingsProvider = SettingsProvider();
  late String selectedBoard;
  late String selectedPattern;
  late bool withSound;

  getBoardDisplay() {
    switch (settingsProvider.selectedBoard) {
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
        boardDisplay = settingsProvider.selectedBoard;
    }
  }

  loadPrefs() async {
    SharedPreferences savedPref = await SharedPreferences.getInstance();

    setState(() {
      withSound = savedPref.getBool('withSound') ?? true;
      selectedBoard = savedPref.getString('selectedBoard') ?? "City Walk";
      selectedPattern = savedPref.getString('selectedPattern') ?? "One Line";
    });
  }

  @override
  void initState() {
    super.initState();
    loadPrefs().then((_) {
      getBoardDisplay();
      InterstitialAd.load(
          adUnitId: AdHelper.interstitialAdUnitId,
          request: AdRequest(),
          adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
            this._interstitialAd = ad;
            _isInterstitialAdReady = true;
          }, onAdFailedToLoad: (LoadAdError error) {
            print("Failed to Load Interstitial Ad ${error.message}");
          })); //Interstitial Ads
    });
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
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.blockSizeHorizontal * 5),
            child: IconButton(
              icon: Icon(
                Icons.share,
                size: SizeConfig.blockSizeHorizontal * 4,
              ),
              tooltip: 'Screenshot',
              onPressed: takeScreenShot,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.blockSizeHorizontal * 5),
            child: IconButton(
              icon: Icon(
                Icons.refresh,
                size: SizeConfig.blockSizeHorizontal * 4,
              ),
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
          ),
        ],
      ),
      body: Container(
        color: Colors.yellow[50],
        child: Screenshot(
          controller: screenshotController,
          child: Column(children: [
            Container(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.blockSizeVertical * 1),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 10, 8.0, 0),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.blockSizeHorizontal * 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Things found here->",
                              style: TextStyle(
                                  fontFamily: 'CaveatBrush',
                                  fontSize: SizeConfig.blockSizeHorizontal * 5,
                                  color: Colors.blue),
                            ),
                            Text(
                              boardDisplay,
                              maxLines: 1,
                              style: TextStyle(
                                  fontFamily: 'CaveatBrush',
                                  fontSize: SizeConfig.blockSizeHorizontal * 5,
                                  color: Colors.purple),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.blockSizeHorizontal * 5),
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
                                            SizeConfig.blockSizeHorizontal * 5,
                                        color: Colors.blue),
                                  ),
                                ),
                                Text(
                                  settingsProvider.selectedPattern,
                                  style: TextStyle(
                                      fontFamily: 'CaveatBrush',
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal * 5,
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
            ),
            bingoBanner(),
            bingoBoard(screenshotController),
          ]),
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
