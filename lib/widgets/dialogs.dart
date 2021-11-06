import 'package:flutter/material.dart';
import 'package:material_dialogs/material_dialogs.dart';

import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:scavenger_hunt_bingo/settings.dart';
import 'package:scavenger_hunt_bingo/widgets/audio.dart';

showWinningDialog(context) {
  Dialogs.materialDialog(
    color: Colors.yellow.shade50,
    msg: 'BINGO!',
    title: 'Congratulations,',
    context: context,
    lottieBuilder: Lottie.asset('assets/32585-fireworks-display.json'),
    actions: [
      IconsButton(
        onPressed: () {
          stopSound();
          Navigator.of(context).pop();
        },
        text: 'Close',
        iconData: Icons.exit_to_app,
        color: Colors.blue,
        textStyle: TextStyle(color: Colors.white),
        iconColor: Colors.white,
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
        iconData: Icons.auto_awesome,
        color: Colors.purple,
        textStyle: TextStyle(color: Colors.white),
        iconColor: Colors.white,
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
      case "Cross":
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
    var size = MediaQuery.of(context).size;
    getSelectedPatternImage(widget.selectedPattern);
    return Dialog(
      child: Container(
        width: size.width,
        height: size.width / 2,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: ExactAssetImage(winningImage), fit: BoxFit.contain)),
      ),
    );
  }
}
