import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../data/winning_patterns.dart';
import '../providers/settings_provider.dart';
import 'audio.dart';

import 'game_state.dart';

class ListTileWidget extends StatefulWidget {
  final String name;
  final IconData icon;
  final int index;
  final ScreenshotController screenshotController;

  ListTileWidget({
    required this.name,
    required this.index,
    required this.icon,
    required this.screenshotController,

    // required this.isSelected,
  });

  @override
  ListTileWidgetState createState() => ListTileWidgetState();
}

class ListTileWidgetState extends State<ListTileWidget> {
  bool isSelected = false;
  List winPattern = [];

  addToSelectedTiles(int) {
    selectedTiles.add(int);
  }

  removeFromSelectedTiles(int) {
    selectedTiles.removeWhere((element) => element == int);
  }

  getWinPattern(pattern) {
    if (pattern == "One Line" && winningPattern != null) {
      winPattern = Patterns.oneLine[winningPattern];
    } else if (pattern == "Letter X") {
      winPattern = Patterns.cross;
    } else if (pattern == "Full Card") {
      winPattern = Patterns.full;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var settingsProvider = Provider.of<SettingsProvider>(context);
    if (gameWon) getWinPattern(settingsProvider.selectedPattern);
    var fontColor = gameWon && winPattern.contains(widget.index)
        ? Colors.blue[50]
        : Colors.purple;
    return GestureDetector(
        onTap: () {
          if (!disableTiles) {
            setState(() {
              if (isSelected) {
                isSelected = !isSelected;
                removeFromSelectedTiles(widget.index);
              } else {
                isSelected = !isSelected;
                if (settingsProvider.withSound) playSound("woosh.mp3");
                addToSelectedTiles(widget.index);
              }
            });

            if (settingsProvider.selectedPattern == "One Line" &&
                selectedTiles.length > 4) {
              findOneLineWinner(context, settingsProvider.withSound,
                  widget.screenshotController);
            }
            if (settingsProvider.selectedPattern == "Letter X" &&
                selectedTiles.length > 8) {
              findCrossWinner(context, settingsProvider.withSound,
                  widget.screenshotController);
            }
            if (settingsProvider.selectedPattern == "Full Card" &&
                selectedTiles.length == 25) {
              findFullCardWinner(context, settingsProvider.withSound,
                  widget.screenshotController);
            }
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
                  image: gameWon && winPattern.contains(widget.index)
                      ? DecorationImage(
                          image: AssetImage("assets/images/selectedImage.png"))
                      : null,
                  // shape: BoxShape.circle,
                  color: isSelected ? Colors.blue : null,
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
                                      color: fontColor,
                                      fontSize: size.width * 0.0375)
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
                                        color: fontColor,
                                      ),
                                    ),
                                  )
                                ],
                              ))),
          ),
        ));
  }
}