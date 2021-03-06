import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:scavenger_hunt_bingo/providers/settings_provider.dart';
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
  bool canShare = false;

  getBoardDisplay() {
    switch (settingsProvider.selectedBoard) {
      case "City Walk":
        boardDisplay = "City Walk";
        canShare = true;
        break;
      case "Trail Walk":
        boardDisplay = "Trail Walk";
        canShare = true;
        break;
      case "Stay Indoors":
        boardDisplay = "Stay Indoors";
        canShare = true;
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
        canShare = true;
        break;
      case "Virtual Meeting":
        boardDisplay = "Virtual Meeting";
        canShare = true;
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
            debugPrint("Failed to Load Interstitial Ad ${error.message}");
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
    var settingsProvider = Provider.of<SettingsProvider>(context);
    var selectedBoard = settingsProvider.selectedBoard;
    return Scaffold(
        appBar: NewGradientAppBar(
          automaticallyImplyLeading: false,
          title: AutoSizeText(
            "Scavenger Bingo",
            style: TextStyle(
              color: Colors.yellow[50],
              fontFamily: 'CaveatBrush',
              fontSize: SizeConfig.blockSizeHorizontal * 10,
            ),
          ),
          gradient: LinearGradient(colors: [Colors.purple, Colors.blue]),
          actions: <Widget>[
            Padding(
                padding:
                    EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 3),
                child: canShare
                    ? IconButton(
                        icon: Icon(
                          Icons.share,
                          size: SizeConfig.blockSizeHorizontal * 4,
                        ),
                        tooltip: 'Screenshot',
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    backgroundColor: Colors.yellow[50],
                                    title: Text(
                                      "Share your card?",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontFamily: 'CaveatBrush',
                                        fontSize:
                                            SizeConfig.blockSizeHorizontal * 6,
                                      ),
                                    ),
                                    content: Text(
                                      "If sharing content online please do so safely and respectfully. Click Cancel to return to the card, OK to take a screenshot and share.",
                                      style: TextStyle(
                                        color: Colors.purple,
                                        fontFamily: 'CaveatBrush',
                                        fontSize:
                                            SizeConfig.blockSizeHorizontal * 4,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontFamily: 'CaveatBrush',
                                            fontSize:
                                                SizeConfig.blockSizeHorizontal *
                                                    6,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal:
                                                SizeConfig.blockSizeHorizontal *
                                                    3),
                                        child: TextButton(
                                          child: Text(
                                            "OK",
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontFamily: 'CaveatBrush',
                                              fontSize: SizeConfig
                                                      .blockSizeHorizontal *
                                                  6,
                                            ),
                                          ),
                                          onPressed: () {
                                            takeScreenShot();
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      )
                                    ],
                                  ));
                        })
                    : null),
            Padding(
              padding:
                  EdgeInsets.only(right: SizeConfig.blockSizeHorizontal * 3),
              child: IconButton(
                icon: Icon(
                  Icons.refresh,
                  size: SizeConfig.blockSizeHorizontal * 4,
                ),
                tooltip: 'Restart Game',
                onPressed: () {
                  debugPrint("Restart pressed");
                  showRestartAlertDialog(
                      context, result, _isInterstitialAdReady, _interstitialAd);
                },
              ),
            ),
          ],
        ),
        body: Container(
          width: SizeConfig.safeBlockHorizontal * 100,
          height: (SizeConfig.safeBlockVertical * 100),
          decoration: BoxDecoration(
              color: Colors.yellow[50],
              border: Border(
                bottom: BorderSide(
                  color: Colors.purple,
                  width: 3,
                ),
              )),
          child: Screenshot(
            controller: screenshotController,
            child: Column(children: [
              Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.blockSizeVertical * 0.5),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
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
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 5,
                                    color: Colors.blue),
                              ),
                              Text(
                                boardDisplay,
                                maxLines: 1,
                                style: TextStyle(
                                    fontFamily: 'CaveatBrush',
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 5,
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
                                              SizeConfig.blockSizeHorizontal *
                                                  5,
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
                                                selectedPattern:
                                                    selectedPattern,
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
              bingoBoard(selectedBoard, screenshotController),
            ]),
          ),
        ),
        bottomNavigationBar: bannerAdContainer);
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
