import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';
import '../widgets/game_state.dart';
import 'arrays.dart';

setRandomList(BuildContext context, String selectedBoard) {
  var settings = Provider.of<SettingsProvider>(context, listen: false);
  List<String> _array = [];
  var _iconData = [];
  List<String> selectedList = settings.currentGame as List<String>;

  if (selectedTiles.length == 0) {
    selectedList = [];
    switch (selectedBoard) {
      case "City Walk":
        _array = Resources.city;
        _iconData = [];
        break;
      case "Trail Walk":
        _array = Resources.trail;
        _iconData = [];
        break;
      case "Stay Indoors":
        _array = Resources.indoors;
        _iconData = [];
        break;
      case "Waiting Room":
        _array = Resources.waitingRoom;
        _iconData = [];
        break;
      case "Virtual Meeting":
        _array = Resources.virtual;
        _iconData = [];
        break;
      case "Family Room":
        _array = Resources.familyRoom;
        _iconData = [];
        break;
      case "Bedroom":
        _array = Resources.bedroom;
        _iconData = [];
        break;
      case "Halloween":
        _array = Resources.halloween;
        _iconData = [];
        break;
      case "Christmas":
        _array = Resources.christmas;
        _iconData = [];
        break;
      case "City with Images":
        _array = [];
        _iconData = Resources.cityIcons;
        break;
      case "Trail with Images":
        _array = [];
        _iconData = Resources.cityIcons;
        break;
      case "Indoors with Images":
        _array = [];
        _iconData = Resources.indoorIcons;
        break;
      case "Grocery Store with Images":
        _array = [];
        _iconData = Resources.grocery;
        break;
      case "Classroom with Images":
        _array = [];
        _iconData = Resources.classroom;
        break;
      case "Restaurant with Images":
        _array = [];
        _iconData = Resources.restaurant;
        break;
    }

    if (!selectedBoard.contains("Images")) {
      _array.shuffle();
      selectedList = _array.sublist(0, 25);
    } else {
      _iconData.shuffle();
      List temp = [];
      temp = _iconData.sublist(0, 25);
      for (var i = 0; i < temp.length; i++) {
        selectedList.add(temp[i].name);
      }
    }

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
