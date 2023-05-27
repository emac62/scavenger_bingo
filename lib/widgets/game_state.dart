import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../data/winning_patterns.dart';
import '../providers/settings_provider.dart';
import 'audio.dart';
import 'dialogs.dart';

// List selectedList = [];
List<int> selectedTiles = [];
List result = [];
bool gameWon = false;
var winningPattern;
bool disableTiles = false;

findOneLineWinner(
  context,
  bool withSound,
  ScreenshotController screenshotController,
) {
  var settings = Provider.of<SettingsProvider>(context, listen: false);
  int gamesWon = settings.gamesWon;

  for (var i = 0; i < Patterns.oneLine.length; i++) {
    result = Patterns.oneLine[i]
        .where((element) => !selectedTiles.contains(element))
        .toList();
    if (result.isEmpty) {
      winningPattern = i;

      disableTiles = true;
      result.clear();
      gamesWon++;
      settings.setGamesWon(gamesWon);
      gameWon = true;
      int gamesForAd = gamesWon + settings.gamesStarted;

      if (withSound) playSound('fireworks.mp3');
      Future.delayed(const Duration(milliseconds: 1500), () {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (_) => WinningDialog(
                withSound: withSound,
                screenshotController: screenshotController,
                gamesForAd: gamesForAd));
      });

      // showWinningDialog(context, withSound, screenshotController, gamesForAd);

      break;
    }
  }
}

findCrossWinner(
  context,
  bool withSound,
  ScreenshotController screenshotController,
) {
  var settings = Provider.of<SettingsProvider>(context, listen: false);
  int gamesWon = settings.gamesWon;
  result = Patterns.cross
      .where((element) => !selectedTiles.contains(element))
      .toList();
  if (result.isEmpty) {
    result.clear();
    gameWon = true;
    gamesWon++;
    settings.setGamesWon(gamesWon);
    disableTiles = true;
    int gamesForAd = gamesWon + settings.gamesStarted;
    if (withSound) playSound('fireworks.mp3');
    Future.delayed(const Duration(milliseconds: 2500), () {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => WinningDialog(
              withSound: withSound,
              screenshotController: screenshotController,
              gamesForAd: gamesForAd));
    });
  }
}

findFullCardWinner(
  context,
  bool withSound,
  ScreenshotController screenshotController,
) {
  var settings = Provider.of<SettingsProvider>(context, listen: false);
  int gamesWon = settings.gamesWon;
  result = Patterns.full
      .where((element) => !selectedTiles.contains(element))
      .toList();
  if (result.isEmpty) {
    result.clear();
    gameWon = true;
    gamesWon++;
    settings.setGamesWon(gamesWon);
    disableTiles = true;
    int gamesForAd = gamesWon + settings.gamesStarted;
    if (withSound) playSound('fireworks.mp3');
    Future.delayed(Duration(milliseconds: 2500), () {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) => WinningDialog(
              withSound: withSound,
              screenshotController: screenshotController,
              gamesForAd: gamesForAd));
    });
  }
}
