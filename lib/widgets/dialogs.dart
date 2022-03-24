import 'dart:io';

import 'package:flutter/material.dart';
import 'package:material_dialogs/material_dialogs.dart';

import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:path_provider/path_provider.dart';

import 'package:scavenger_hunt_bingo/settings.dart';
import 'package:scavenger_hunt_bingo/widgets/audio.dart';
import 'package:scavenger_hunt_bingo/widgets/size_config.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

showWinningDialog(
    context, bool withSound, ScreenshotController screenshotController) {
  Dialogs.materialDialog(
    color: Colors.white,
    title: 'BINGO!',
    titleStyle: TextStyle(
      color: Colors.purple,
      fontSize: SizeConfig.safeBlockHorizontal * 10,
      fontFamily: 'CaveatBrush',
    ),
    context: context,
    lottieBuilder: Lottie.asset('assets/32585-fireworks-display.json'),
    actions: [
      Column(
        children: [
          IconsButton(
            onPressed: () {
              stopSound();
              Navigator.of(context).pop();
            },
            text: 'Close',
            color: Colors.blue,
            textStyle: TextStyle(
              color: Colors.yellow[50],
              fontSize: SizeConfig.safeBlockHorizontal * 3,
            ),
            iconData: Icons.exit_to_app,
            iconColor: Colors.yellow[50],
          ),
          IconsButton(
            onPressed: () {
              stopSound();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
            text: 'New Game',
            color: Colors.purple,
            textStyle: TextStyle(
              color: Colors.yellow[50],
              fontSize: SizeConfig.safeBlockHorizontal * 3,
            ),
            iconData: Icons.auto_awesome,
            iconColor: Colors.yellow[50],
          ),
          IconsButton(
            onPressed: () async {
              stopSound();
              final Size size = MediaQuery.of(context).size;
              final uint8List = await screenshotController.capture();
              String tempPath = (await getTemporaryDirectory()).path;
              File file = File('$tempPath/Bingo.png');
              await file.writeAsBytes(uint8List!);
              await Share.shareFiles(
                [file.path],
                text: "Shared from Scavenger Hunt Bingo!",
                sharePositionOrigin:
                    Rect.fromLTWH(0, 0, size.width, size.height / 2),
              );
              Navigator.of(context).pop();
            },
            text: 'Share',
            color: Colors.blue,
            textStyle: TextStyle(
              color: Colors.yellow[50],
              fontSize: SizeConfig.safeBlockHorizontal * 3,
            ),
            iconData: Icons.share,
            iconColor: Colors.yellow[50],
          ),
        ],
      ),
    ],
  );
}

showRestartAlertDialog(
    context, result, _isInterstitialAdReady, _interstitialAd) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text(
      "Cancel",
      style: TextStyle(
        color: Colors.blue,
        fontFamily: 'CaveatBrush',
        fontSize: SizeConfig.blockSizeHorizontal * 6,
      ),
    ),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: Text(
      "OK",
      style: TextStyle(
        color: Colors.blue,
        fontFamily: 'CaveatBrush',
        fontSize: SizeConfig.blockSizeHorizontal * 6,
      ),
    ),
    onPressed: () {
      result.clear();
      if (_isInterstitialAdReady) _interstitialAd.show();

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SettingsPage()),
      );
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    backgroundColor: Colors.yellow[50],
    title: Text(
      "Restart the Game?",
      style: TextStyle(
        color: Colors.blue,
        fontFamily: 'CaveatBrush',
        fontSize: SizeConfig.blockSizeHorizontal * 6,
      ),
    ),
    content: Text(
      "Restarting the game will display a video ad. You will be able to close the ad after 5 seconds. Thank you.",
      style: TextStyle(
        color: Colors.purple,
        fontFamily: 'CaveatBrush',
        fontSize: SizeConfig.blockSizeHorizontal * 4,
      ),
    ),
    actions: [
      cancelButton,
      Padding(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.blockSizeHorizontal * 3),
        child: continueButton,
      ),
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showWinningPattern(context, String pattern) {
  AlertDialog(
    title: Text(pattern),
    content: Image.asset('OneLineWinners.png'),
    actions: <Widget>[
      TextButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ],
  );
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
        winningImage = 'assets/images/OneLineWinners.png';
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
