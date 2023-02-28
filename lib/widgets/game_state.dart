import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../data/winning_patterns.dart';
import '../providers/settings_provider.dart';
import 'audio.dart';
import 'dialogs.dart';

List<int> selectedTiles = [];
List result = [];

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
      result.clear();

      gamesWon++;
      settings.setGamesWon(gamesWon);
      int gamesForAd = gamesWon + settings.gamesStarted;
      if (withSound) playSound('fireworks.mp3');
      showWinningDialog(context, withSound, screenshotController, gamesForAd);
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

    gamesWon++;
    settings.setGamesWon(gamesWon);
    int gamesForAd = gamesWon + settings.gamesStarted;
    if (withSound) playSound('fireworks.mp3');
    showWinningDialog(context, withSound, screenshotController, gamesForAd);
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

    gamesWon++;
    settings.setGamesWon(gamesWon);
    int gamesForAd = gamesWon + settings.gamesStarted;
    if (withSound) playSound('fireworks.mp3');
    showWinningDialog(context, withSound, screenshotController, gamesForAd);
  }
}
