import 'dart:io';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:path_provider/path_provider.dart';

import 'package:scavenger_hunt_bingo/settings.dart';
import 'package:scavenger_hunt_bingo/widgets/audio.dart';
import 'package:scavenger_hunt_bingo/utils/size_config.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../main.dart';
import 'ad_helper.dart';
import 'game_state.dart';

class WinningDialog extends StatefulWidget {
  WinningDialog({
    Key? key,
    required this.withSound,
    required this.screenshotController,
    required this.gamesForAd,
  }) : super(key: key);
  final bool withSound;
  final ScreenshotController screenshotController;
  final int gamesForAd;

  @override
  State<WinningDialog> createState() => _WinningDialogState();
}

class _WinningDialogState extends State<WinningDialog> {
  late InterstitialAd interstitialAd;
  bool isInterstitialAdReady = false;

  late ConfettiController _controllerCenter;

  late Image bgBingo;

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
    interstitialAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controllerCenter.play();

    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Dialog(
        child: Container(
          width: SizeConfig.screenWidth < 600
              ? SizeConfig.blockSizeHorizontal * 100
              : SizeConfig.blockSizeHorizontal * 80,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                Colors.purple,
                Colors.blue,
              ])),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Image.asset(
              'assets/images/winningImg.png',
            ),
            Align(
              alignment: Alignment.center,
              child: ConfettiWidget(
                confettiController: _controllerCenter,
                blastDirectionality: BlastDirectionality
                    .explosive, // don't specify a direction, blast randomly
                shouldLoop:
                    true, // start again as soon as the animation is finished
                colors: const [
                  Colors.blue,
                  Colors.yellow,
                  Color.fromRGBO(255, 253, 231, 1),
                ], // manually specify the colors to be used
                createParticlePath: drawStar,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.blockSizeVertical * 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DialogButton(
                    onPressed: () {
                      stopSound();
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
                        stopSound();
                        setState(() {
                          selectedTiles.clear();
                          winningPattern = null;
                          gameWon = false;
                        });

                        if (widget.gamesForAd % 3 == 0) {
                          if (isInterstitialAdReady) interstitialAd.show();
                        }
                        Navigator.push(
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
                    stopSound();
                    final Size size = MediaQuery.of(context).size;
                    final uint8List =
                        await widget.screenshotController.capture();
                    String tempPath = (await getTemporaryDirectory()).path;
                    File file = File('$tempPath/Bingo.png');
                    await file.writeAsBytes(uint8List!);
                    await Share.shareXFiles(
                      [XFile(file.path)],
                      subject: "Shared from Scavenger Hunt Bingo!",
                      sharePositionOrigin:
                          Rect.fromLTWH(0, 0, size.width, size.height / 2),
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
    );
  }
}

class DialogButton extends StatelessWidget {
  const DialogButton({
    Key? key,
    required this.onPressed,
    required this.title,
    required this.icon,
  }) : super(key: key);
  final VoidCallback onPressed;
  final String title;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          minimumSize: SizeConfig.screenWidth < 600
              ? Size(SizeConfig.blockSizeHorizontal * 30,
                  SizeConfig.blockSizeVertical * 4)
              : Size(SizeConfig.blockSizeHorizontal * 35,
                  SizeConfig.blockSizeVertical * 4),
          backgroundColor: Colors.yellow[50],
          foregroundColor: Colors.purple,
          elevation: 10,
          textStyle: TextStyle(
              fontSize: SizeConfig.screenWidth < 600
                  ? SizeConfig.blockSizeVertical * 3
                  : SizeConfig.blockSizeVertical * 4,
              fontFamily: "CaveatBrush")),
      onPressed: onPressed,
      icon: icon,
      label: Text(title),
    );
  }
}

class ImageDialog extends StatefulWidget {
  final String selectedPattern;

  const ImageDialog({Key? key, required this.selectedPattern})
      : super(key: key);
  @override
  _ImageDialogState createState() => _ImageDialogState();
}

class _ImageDialogState extends State<ImageDialog> {
  var winningImage;

  getSelectedPatternImage(String selectedPattern) {
    switch (selectedPattern) {
      case "One Line":
        winningImage = 'assets/images/OneLinePort.png';
        break;
      case "Letter X":
        winningImage = 'assets/images/Cross.png';
        break;
      case "Full Card":
        winningImage = 'assets/images/Full.png';
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    getSelectedPatternImage(widget.selectedPattern);
    return Dialog(
      child: Container(
        width: SizeConfig.blockSizeHorizontal * 100,
        height: SizeConfig.blockSizeVertical * 60,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: ExactAssetImage(winningImage), fit: BoxFit.contain),
          color: Colors.yellow[50],
        ),
      ),
    );
  }
}
