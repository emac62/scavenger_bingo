import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:scavenger_hunt_bingo/main.dart';
import 'package:scavenger_hunt_bingo/arrays.dart';
import 'package:scavenger_hunt_bingo/widgets/dialogs.dart';
import 'package:scavenger_hunt_bingo/winning_patterns.dart';

List<Widget> listTileWidgets(selectedBoard) {
  List<Widget> _widget = [];

  var _buttonName = [];

  if (selectedBoard == "City") {
    selectedBoard = Resources.city;
  } else if (selectedBoard == "Trail") {
    selectedBoard = Resources.trail;
  } else {
    selectedBoard = Resources.indoors;
  }
  selectedBoard.shuffle();
  var selectedList = selectedBoard.sublist(0, 25);

  selectedList.forEach((item) {
    _buttonName.add(item.toString());
  });

  for (var i = 0; i < _buttonName.length; i++) {
    _widget.add(ListTileWidget(
      name: _buttonName[i],
      index: i,
      isSelected: false,
    ));
  }

  return _widget;
}

Widget bingoBoard() {
  return Builder(builder: (context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0.0, 10, 10),
      child: Container(
        child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 5,
            childAspectRatio: (size.width / size.height) * 2,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            children: listTileWidgets(selectedBoard)),
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
    showWinningDialog(context);
  }
}

// ignore: must_be_immutable
class ListTileWidget extends StatefulWidget {
  final String name;
  final int index;
  bool isSelected;

  ListTileWidget(
      {required this.name, required this.index, required this.isSelected});

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
              addToSelectedTiles(widget.index);
            }
          });
          if (selectedPattern == "One Line") {
            findOneLineWinner(context);
          } else if (selectedPattern == "Cross") {
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
                  child: ListTile(
                      contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
                      dense: true,
                      title: AutoSizeText(
                        widget.index == 12 ? "FREE" : widget.name.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: (widget.index != 12)
                            ? TextStyle(
                                fontFamily: 'CaveatBrush',
                                fontSize: size.width * 0.025,
                                color: Colors.purple)
                            : TextStyle(
                                fontFamily: 'CaveatBrush',
                                fontSize: size.width * 0.1,
                                color: Colors.blue[100]),
                      )),
                )),
          ),
        ));
  }
}
