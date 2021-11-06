import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:scavenger_hunt_bingo/arrays.dart';
import 'package:scavenger_hunt_bingo/widgets/audio.dart';
import 'package:scavenger_hunt_bingo/widgets/dialogs.dart';
import 'package:scavenger_hunt_bingo/winning_patterns.dart';

List<Widget> listTileWidgets(String selectedBoard, String selectedPattern) {
  List<Widget> _widget = [];
  var _buttonName = [];
  var _array = [];
  var _iconData = [];
  var selectedList = [];

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
    case "City Walk with Images":
      _array = [];
      _iconData = Resources.cityIcons;
      break;
    case "Trail Walk with Images":
      _array = [];
      _iconData = Resources.cityIcons;
      break;
    case "Stay Indoors with Images":
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
  }

  if (!selectedBoard.contains("Images")) {
    _array.shuffle();
    selectedList = _array.sublist(0, 25);

    selectedList.forEach((item) {
      _buttonName.add(item.toString());
    });

    for (var i = 0; i < _buttonName.length; i++) {
      _widget.add(ListTileWidget(
        name: _buttonName[i],
        icon: IconData(i),
        index: i,
        isSelected: false,
        pattern: selectedPattern,
      ));
    }

    return _widget;
  } else {
    _iconData.shuffle();
    selectedList = _iconData.sublist(0, 25);

    for (var i = 0; i < selectedList.length; i++) {
      _widget.add(ListTileWidget(
        name: selectedList[i].name,
        index: i,
        isSelected: false,
        icon: selectedList[i].icon,
        pattern: selectedPattern,
      ));
    }

    return _widget;
  }
}

Widget bingoBoard(String selectedBoard, String selectedPattern) {
  return Builder(builder: (context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0.0, 10, 0),
      child: Container(
        child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 5,
            childAspectRatio: (size.width / size.height) * 1.8,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            children: listTileWidgets(selectedBoard, selectedPattern)),
      ),
    );
  });
}

List<int> selectedTiles = [];

addToSelectedTiles(int) {
  selectedTiles.add(int);
}

removeFromSelectedTiles(int) {
  selectedTiles.removeWhere((element) => element == int);
}

List result = [];

findOneLineWinner(context) {
  for (var i = 0; i < Patterns.oneLine.length; i++) {
    result = Patterns.oneLine[i]
        .where((element) => !selectedTiles.contains(element))
        .toList();

    if (result.isEmpty) {
      result.clear();
      selectedTiles.clear();
      playSound('fireworks.mp3');
      showWinningDialog(context);
      break;
    }
  }
}

findCrossWinner(context) {
  result = Patterns.cross
      .where((element) => !selectedTiles.contains(element))
      .toList();
  if (result.isEmpty) {
    result.clear();
    selectedTiles.clear();
    playSound('fireworks.mp3');
    showWinningDialog(context);
  }
}

findFullCardWinner(context) {
  result = Patterns.full
      .where((element) => !selectedTiles.contains(element))
      .toList();
  if (result.isEmpty) {
    result.clear();
    selectedTiles.clear();
    playSound('fireworks.mp3');
    showWinningDialog(context);
  }
}

checkForWinner(String selectedPattern) {}

// ignore: must_be_immutable
class ListTileWidget extends StatefulWidget {
  final String name;
  final IconData icon;
  final int index;
  bool isSelected;
  final String pattern;

  ListTileWidget(
      {required this.name,
      required this.index,
      required this.isSelected,
      required this.icon,
      required this.pattern});

  @override
  ListTileWidgetState createState() => ListTileWidgetState();
}

class ListTileWidgetState extends State<ListTileWidget> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: () {
          setState(() {
            if (widget.isSelected) {
              widget.isSelected = !widget.isSelected;
              removeFromSelectedTiles(widget.index);
            } else {
              widget.isSelected = !widget.isSelected;
              playSound("woosh.mp3");
              addToSelectedTiles(widget.index);
            }
          });

          if (widget.pattern == "One Line") {
            findOneLineWinner(context);
          } else if (widget.pattern == "Cross") {
            findCrossWinner(context);
          } else {
            findFullCardWinner(context);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.purple),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
                decoration: BoxDecoration(
                  // shape: BoxShape.circle,
                  color: widget.isSelected ? Colors.blue : null,
                ),
                child: Center(
                    child: (widget.icon == IconData(widget.index))
                        ? ListTile(
                            contentPadding:
                                EdgeInsets.only(left: 0.0, right: 0.0),
                            dense: true,
                            title: AutoSizeText(
                              widget.index == 12
                                  ? "FREE"
                                  : widget.name.toUpperCase(),
                              textAlign: TextAlign.center,
                              wrapWords: false,
                              minFontSize: 0,
                              stepGranularity: 0.1,
                              style: (widget.index != 12)
                                  ? TextStyle(
                                      fontFamily: 'CaveatBrush',
                                      color: Colors.purple,
                                      fontSize: size.width * 0.04)
                                  : TextStyle(
                                      fontFamily: 'CaveatBrush',
                                      color: Colors.blue[100],
                                      fontSize: size.width * 0.1),
                            ))
                        : (widget.index == 12)
                            ? AutoSizeText(
                                "FREE",
                                style: TextStyle(
                                    color: Colors.blue[100],
                                    fontFamily: 'CaveatBrush',
                                    fontSize: size.width * 0.1),
                                textAlign: TextAlign.center,
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    widget.icon,
                                    color: Colors.purple,
                                    size: size.width * 0.05,
                                  ),
                                  Flexible(
                                    child: AutoSizeText(
                                      widget.name.toUpperCase(),
                                      textAlign: TextAlign.center,
                                      wrapWords: false,
                                      minFontSize: 0,
                                      style: TextStyle(
                                        fontFamily: 'CaveatBrush',
                                        fontSize: size.width * 0.03,
                                        color: Colors.purple,
                                      ),
                                    ),
                                  )
                                ],
                              ))),
          ),
        ));
  }
}
