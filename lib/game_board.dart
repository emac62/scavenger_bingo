import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:scavenger_hunt_bingo/main.dart';
import 'package:scavenger_hunt_bingo/providers/settings_provider.dart';
import 'package:scavenger_hunt_bingo/settings.dart';
import 'package:scavenger_hunt_bingo/widgets/ad_helper.dart';
import 'package:scavenger_hunt_bingo/widgets/banner_ad_widget.dart';
import 'package:scavenger_hunt_bingo/widgets/bingo_banner.dart';
import 'package:scavenger_hunt_bingo/widgets/bingo_grid.dart';
import 'package:scavenger_hunt_bingo/widgets/dialogs.dart';
import 'package:scavenger_hunt_bingo/utils/size_config.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

import 'widgets/game_state.dart';

const int maxFailedLoadAttempts = 3;

class GameBoard extends StatefulWidget {
  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  late InterstitialAd interstitialAd;
  bool isInterstitialAdReady = false;
  BannerAdContainer bannerAdContainer = BannerAdContainer();
  String boardDisplay = "";

  late String selectedBoard;
  late String selectedPattern;
  late bool withSound;
  bool canShare = false;

  getBoardDisplay(selectedBoard) {
    switch (selectedBoard) {
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
      case "Family Room":
        boardDisplay = "Family Room";
        canShare = true;
        break;
      case "Bedroom":
        boardDisplay = "Bedroom";
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
      case "Halloween":
        boardDisplay = "Halloween";
        canShare = true;
        break;
      case "Christmas":
        boardDisplay = "Christmas";
        canShare = true;
        break;
      default:
        boardDisplay = selectedBoard;
    }
  }

  loadPrefs() {
    var settings = Provider.of<SettingsProvider>(context, listen: false);
    setState(() {
      withSound = settings.withSound;
      selectedBoard = settings.selectedBoard;
      debugPrint("game board init: $selectedBoard");
      selectedPattern = settings.selectedPattern;
    });
  }

  @override
  void initState() {
    super.initState();
    loadPrefs();
    InterstitialAd.load(
        adUnitId: useTestAds
            ? AdHelper.testInterstitialAdUnitId
            : AdHelper.interstitialAdUnitId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
          this.interstitialAd = ad;
          isInterstitialAdReady = true;
        }, onAdFailedToLoad: (LoadAdError error) {
          debugPrint("Failed to Load Interstitial Ad ${error.message}");
        })); //Interstitial Ads
  }

  @override
  void dispose() {
    super.dispose();

    interstitialAd.dispose();
  }

  final screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    var settingsProvider = Provider.of<SettingsProvider>(context);
    var selectedBoard = settingsProvider.selectedBoard;
    getBoardDisplay(selectedBoard);
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(SizeConfig.blockSizeHorizontal * 12),
          child: NewGradientAppBar(
            automaticallyImplyLeading: false,
            title: AutoSizeText(
              "Scavenger Bingo",
              style: TextStyle(
                color: Colors.yellow[50],
                fontFamily: 'CaveatBrush',
                fontSize: SizeConfig.blockSizeHorizontal * 8,
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
                                              SizeConfig.blockSizeHorizontal *
                                                  6,
                                        ),
                                      ),
                                      content: Text(
                                        "If sharing content online please do so safely and respectfully. Click Cancel to return to the card, OK to take a screenshot and share.",
                                        style: TextStyle(
                                          color: Colors.purple,
                                          fontFamily: 'CaveatBrush',
                                          fontSize:
                                              SizeConfig.blockSizeHorizontal *
                                                  4,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          child: Text(
                                            "Cancel",
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontFamily: 'CaveatBrush',
                                              fontSize: SizeConfig
                                                      .blockSizeHorizontal *
                                                  6,
                                            ),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: SizeConfig
                                                      .blockSizeHorizontal *
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
                    result.clear();
                    selectedTiles.clear();
                    if ((settingsProvider.gamesWon +
                                settingsProvider.gamesStarted) %
                            2 ==
                        0) {
                      if (isInterstitialAdReady) interstitialAd.show();
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsPage()),
                    );
                    // showRestartAlertDialog(context, result,
                    //     _isInterstitialAdReady, _interstitialAd);
                  },
                ),
              ),
            ],
          ),
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
                        padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
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
              BingoGrid(
                  selectedBoard: selectedBoard,
                  screenshotController: screenshotController)
              // bingoBoard(selectedBoard, screenshotController),
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

    Share.shareXFiles(
      [XFile(file.path)],
      subject: "Shared from Scavenger Hunt Bingo!",
      sharePositionOrigin: Rect.fromLTWH(0, 0, size.width, size.height / 2),
    );
  }
}
