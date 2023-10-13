import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:scavenger_hunt_bingo/providers/controller.dart';

import '../providers/settings_provider.dart';

import 'arrays.dart';
import 'bingo_card.dart';

setRandomList(BuildContext context, String selectedBoard) {
  var settings = Provider.of<SettingsProvider>(context, listen: false);
  var cont = Provider.of<Controller>(context, listen: false);
  List<String> selectedList = settings.currentGame as List<String>;

  if (cont.selectedTiles.length == 0) {
    selectedList = [];

    Box cardBox = Hive.box<BingoCard>('cards');

    final selectedCard = cardBox.values
        .where(
          (e) => e.name == selectedBoard,
        )
        .toList();
    selectedList = selectedCard[0].items;

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
