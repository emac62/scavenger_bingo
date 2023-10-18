import 'dart:io';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:scavenger_hunt_bingo/widgets/dialog_button.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../main.dart';
import '../providers/controller.dart';
import '../providers/settings_provider.dart';
import '../pages/settings.dart';
import '../utils/size_config.dart';
import '../utils/ad_helper.dart';
import '../utils/audio.dart';

class WinningDialog extends StatefulWidget {
  WinningDialog({
    Key? key,
    required this.screenshotController,
    required this.gamesForAd,
  }) : super(key: key);

  final ScreenshotController screenshotController;
  final int gamesForAd;

  @override
  State<WinningDialog> createState() => _WinningDialogState();
}

class _WinningDialogState extends State<WinningDialog> {
  InterstitialAd? interstitialAd;
  bool isInterstitialAdReady = false;

  late ConfettiController _controllerCenter;

  late Image bgBingo;

  var gameSounds = GameSounds();

  void loadInterstitialAd() {
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
  void initState() {
    super.initState();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 5));

    bgBingo = Image.asset('assets/images/winningImg.png');
    gameSounds.playFireworks();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(bgBingo.image, context);
    loadInterstitialAd();
  }

  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  void dispose() {
    super.dispose();
    _controllerCenter.dispose();
    interstitialAd?.dispose();
    gameSounds.disposeGameSound();
  }

  @override
  Widget build(BuildContext context) {
    _controllerCenter.play();
    var settings = Provider.of<SettingsProvider>(context, listen: false);
    var cont = Provider.of<Controller>(context, listen: false);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(227, 242, 253, 0.5),
      body: SafeArea(
        child: Stack(children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: SizeConfig.screenWidth < 500
                  ? SizeConfig.screenWidth * 0.9
                  : SizeConfig.screenWidth * 0.75,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                    Colors.purple,
                    Colors.blue,
                  ])),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image(image: bgBingo.image),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.blockSizeVertical * 3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          DialogButton(
                            onPressed: () {
                              gameSounds.stopGameSound();
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.close,
                              color: Colors.purple,
                              size: SizeConfig.blockSizeHorizontal * 3.5,
                            ),
                            title: 'Close',
                          ),
                          DialogButton(
                              onPressed: () {
                                setState(() {
                                  gameSounds.stopGameSound();
                                  cont.clearSelectedTiles();
                                  cont.resetWinPattern();
                                  cont.resetGameWon();
                                });

                                if (!settings.removeAds) {
                                  if (widget.gamesForAd % 3 == 0) {
                                    if (isInterstitialAdReady)
                                      interstitialAd?.show();
                                  }
                                }
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SettingsPage()),
                                );
                              },
                              icon: Icon(
                                Icons.refresh,
                                color: Colors.purple,
                                size: SizeConfig.blockSizeHorizontal * 3.5,
                              ),
                              title: "New Game")
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.blockSizeVertical * 3),
                        child: DialogButton(
                          onPressed: () async {
                            gameSounds.stopGameSound();
                            final Size size = MediaQuery.of(context).size;
                            final uint8List =
                                await widget.screenshotController.capture();
                            String tempPath =
                                (await getTemporaryDirectory()).path;
                            File file = File('$tempPath/Bingo.png');
                            await file.writeAsBytes(uint8List!);
                            await Share.shareXFiles(
                              [XFile(file.path)],
                              subject: "Shared from Scavenger Hunt Bingo!",
                              sharePositionOrigin: Rect.fromLTWH(
                                  0, 0, size.width, size.height / 2),
                            );
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.share,
                            color: Colors.purple,
                            size: SizeConfig.blockSizeHorizontal * 3.5,
                          ),
                          title: "Share",
                        )),
                    const SizedBox(
                      height: 25,
                    )
                  ]),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _controllerCenter,
              blastDirectionality: BlastDirectionality
                  .explosive, // don't specify a direction, blast randomly
              shouldLoop:
                  false, // start again as soon as the animation is finished
              colors: const [
                Colors.purple,
                Colors.blue,
                // Colors.yellow,
                // Color.fromRGBO(255, 253, 231, 1),
              ], // manually specify the colors to be used
              createParticlePath: drawStar,
            ),
          ),
        ]),
      ),
    );
  }
}
