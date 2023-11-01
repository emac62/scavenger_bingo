import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:provider/provider.dart';
import 'package:scavenger_hunt_bingo/main.dart';
import 'package:scavenger_hunt_bingo/providers/settings_provider.dart';
import 'package:scavenger_hunt_bingo/pages/settings.dart';
import 'package:scavenger_hunt_bingo/utils/ad_helper.dart';
import 'package:scavenger_hunt_bingo/utils/audio.dart';
import 'package:scavenger_hunt_bingo/widgets/banner_ad_widget.dart';
import 'package:scavenger_hunt_bingo/widgets/bingo_banner.dart';
import 'package:scavenger_hunt_bingo/widgets/bingo_grid.dart';
import 'package:scavenger_hunt_bingo/widgets/dialogs.dart';
import 'package:scavenger_hunt_bingo/utils/size_config.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../providers/controller.dart';

const int maxFailedLoadAttempts = 3;

class GameBoard extends StatefulWidget {
  final bool removeAds;

  const GameBoard({Key? key, required this.removeAds}) : super(key: key);
  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  InterstitialAd? interstitialAd;
  bool isInterstitialAdReady = false;
  BannerAdContainer bannerAdContainer = BannerAdContainer();
  String boardDisplay = "";

  late String selectedBoard;
  late String selectedPattern;

  bool canShare = false;

  getBoardDisplay(selectedBoard) {
    switch (selectedBoard) {
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

      default:
        boardDisplay = selectedBoard;
    }
  }

  loadPrefs() {
    loadInterstitialAd();
    var settings = Provider.of<SettingsProvider>(context, listen: false);
    setState(() {
      selectedBoard = settings.selectedBoard;
      selectedPattern = settings.selectedPattern;
    });
    getBoardDisplay(selectedBoard);
  }

  @override
  void initState() {
    super.initState();
    loadPrefs();
  }

  void loadInterstitialAd() {
    InterstitialAd.load(
        adUnitId: useTestAds
            ? AdHelper.testInterstitialAdUnitId
            : AdHelper.interstitialAdUnitId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
          this.interstitialAd = ad;
          setState(() {
            widget.removeAds
                ? isInterstitialAdReady = false
                : isInterstitialAdReady = true;
          });
        }, onAdFailedToLoad: (LoadAdError error) {
          debugPrint("Failed to Load Interstitial Ad ${error.message}");
        })); //Interstitial Ads
  }

  var gameSounds = GameSounds();

  @override
  void dispose() {
    super.dispose();
    gameSounds.disposeGameSound();
    interstitialAd?.dispose();
  }

  final screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var settingsProvider = Provider.of<SettingsProvider>(context, listen: true);
    var cont = Provider.of<Controller>(context, listen: true);

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "BINGO",
            style: TextStyle(
              color: Colors.yellow[50],
              fontFamily: 'CaveatBrush',
              fontSize: SizeConfig.blockSizeVertical * 5,
            ),
          ),
          toolbarHeight: SizeConfig.blockSizeVertical * 7,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.purple, Colors.blue],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight),
            ),
          ),
          actions: <Widget>[
            Padding(
                padding:
                    EdgeInsets.only(left: SizeConfig.blockSizeHorizontal * 3),
                child: canShare
                    ? TextButton.icon(
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
                                      "Choose how you want to share the image of the card or just save it to your device. Click OK to take a screenshot.",
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
                        },
                        icon: Icon(
                          Icons.share,
                          color: Colors.yellow[50],
                          size: SizeConfig.blockSizeHorizontal * 3.5,
                        ),
                        label: Text(
                          "Share",
                          style: TextStyle(
                              fontFamily: "Roboto",
                              color: Colors.yellow[50],
                              fontSize: SizeConfig.blockSizeVertical * 1.5),
                        ))
                    : null),
            Padding(
              padding:
                  EdgeInsets.only(right: SizeConfig.blockSizeHorizontal * 3),
              child: TextButton.icon(
                icon: Icon(
                  Icons.refresh,
                  size: SizeConfig.blockSizeHorizontal * 4,
                  color: Colors.yellow[50],
                ),
                onPressed: () {
                  cont.clearResult();
                  cont.resetGameWon();
                  cont.clearSelectedTiles();
                  cont.resetWinPattern();

                  if (!settingsProvider.removeAds) {
                    if ((settingsProvider.gamesWon +
                                settingsProvider.gamesStarted) %
                            2 ==
                        0) {
                      if (isInterstitialAdReady) interstitialAd?.show();
                    }
                  }
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                },
                label: Text(
                  "New Game",
                  style: TextStyle(
                      fontFamily: "Roboto",
                      color: Colors.yellow[50],
                      fontSize: SizeConfig.blockSizeVertical * 1.5),
                ),
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
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.blockSizeHorizontal * 5),
                        child: Row(
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
                                  fontSize: SizeConfig.blockSizeHorizontal * 5,
                                  color: Colors.purple),
                            ),
                            IconButton(
                              iconSize: SizeConfig.blockSizeVertical * 3,
                              alignment: Alignment.center,
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
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              bingoBanner(),
              Expanded(
                child: BingoGrid(
                  selectedBoard: selectedBoard,
                  screenshotController: screenshotController,
                ),
              )
              // bingoBoard(selectedBoard, screenshotController),
            ]),
          ),
        ),
        bottomNavigationBar: settingsProvider.removeAds
            ? null
            : showBannerAd
                ? bannerAdContainer
                : null);
  }

  void takeScreenShot() async {
    final Size size = MediaQuery.of(context).size;
    final uint8List = await screenshotController.capture();
    String tempPath = (await getTemporaryDirectory()).path;
    File file = File('$tempPath/Bingo.png');
    await file.writeAsBytes(uint8List!);

    Share.shareXFiles(
      [XFile(file.path)],
      subject: "Shared from Scavenger Hunt Bingo!",
      sharePositionOrigin: Rect.fromLTWH(0, 0, size.width, size.height / 2),
    );
  }
}
