import 'package:flutter/material.dart';
import 'package:material_dialogs/material_dialogs.dart';

import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:scavenger_hunt_bingo/main.dart';

showWinningDialog(context) {
  Dialogs.materialDialog(
    color: Colors.yellow.shade50,
    msg: 'You got a BINGO!',
    title: 'Congratulations,',
    context: context,
    lottieBuilder: Lottie.asset('assets/32585-fireworks-display.json'),
    actions: [
      IconsButton(
        onPressed: () {
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => IntroPage()),
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
