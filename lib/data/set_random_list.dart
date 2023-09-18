import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';
import '../widgets/game_state.dart';
import 'arrays.dart';
import 'bingo_card.dart';

setRandomList(BuildContext context, String selectedBoard) {
  var settings = Provider.of<SettingsProvider>(context, listen: false);

  List<String> selectedList = settings.currentGame as List<String>;

  if (selectedTiles.length == 0) {
    selectedList = [];

    Box cardBox = Hive.box<BingoCard>('cards');
    late BingoCard selectedCard;
    for (var i = 0; i < cardBox.length; i++) {
      final bingoCard = cardBox.get(i) as BingoCard;
      if (bingoCard.name == selectedBoard) {
        selectedCard = bingoCard;
      }
    }
    selectedList = selectedCard.items;

    selectedList.shuffle();
    selectedList = selectedList.sublist(0, 25);

    settings.setCurrentGame(selectedList);

    return selectedList;
  } else {
    selectedList = settings.currentGame as List<String>;

    return selectedList;
  }
}

getIconImage(String name) {
  List iconData = Resources.alphIcons;
  var icon;
  for (int i = 0; i < iconData.length; i++) {
    if (iconData[i].name == name) {
      icon = iconData[i].icon;
    }
  }
  return icon;
}
