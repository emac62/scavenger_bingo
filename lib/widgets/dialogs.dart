import 'package:flutter/material.dart';
import 'package:material_dialogs/material_dialogs.dart';

import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:scavenger_hunt_bingo/settings.dart';
import 'package:scavenger_hunt_bingo/widgets/audio.dart';
import 'package:scavenger_hunt_bingo/widgets/size_config.dart';

showWinningDialog(context, bool withSound) {
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
                MaterialPageRoute(
                    builder: (context) => SettingsPage(withSound: withSound)),
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
            onPressed: () {
              stopSound();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SettingsPage(withSound: withSound)),
              );
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
