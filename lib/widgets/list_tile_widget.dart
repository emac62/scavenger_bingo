import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scavenger_hunt_bingo/utils/size_config.dart';
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
    SizeConfig().init(context);

    var settingsProvider = Provider.of<SettingsProvider>(context);
    if (gameWon) getWinPattern(settingsProvider.selectedPattern);
    var fontColor = gameWon && winPattern.contains(widget.index)
        ? Colors.blue[50]
        : isSelected
            ? Colors.blue[100]
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
                if (settingsProvider.withSound) playSound("woosh.mov");
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
            border: Border.all(color: Colors.purple, width: 0.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
                decoration: BoxDecoration(
                  color: gameWon && winPattern.contains(widget.index)
                      ? Colors.purple
                      : isSelected
                          ? Colors.blue
                          : null,
                ),
                child: Center(
                    child: (widget.icon == IconData(widget.index))
                        ? Text(
                            widget.index == 12
                                ? "FREE"
                                : widget.name.toLowerCase(),
                            textAlign: TextAlign.center,
                            softWrap: true,
                            maxLines: 3,
                            style: TextStyle(
                                fontWeight:
                                    gameWon && winPattern.contains(widget.index)
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                fontFamily: (widget.index == 12)
                                    ? 'CaveatBrush'
                                    : 'Roboto',
                                letterSpacing: -0.5,
                                color: (widget.index != 12)
                                    ? fontColor
                                    : Colors.blue[100],
                                fontSize: (widget.index == 12)
                                    ? SizeConfig.safeBlockHorizontal * 7
                                    : SizeConfig.screenWidth < 400
                                        ? SizeConfig.safeBlockHorizontal * 2.8
                                        : SizeConfig.safeBlockHorizontal * 3))
                        : (widget.index == 12)
                            ? Text(
                                "FREE",
                                style: TextStyle(
                                    color: Colors.blue[100],
                                    fontFamily: 'CaveatBrush',
                                    fontSize:
                                        SizeConfig.blockSizeHorizontal * 7),
                                textAlign: TextAlign.center,
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    widget.icon,
                                    color: fontColor,
                                    size: SizeConfig.blockSizeVertical * 3.5,
                                  ),
                                  Flexible(
                                    child: Text(
                                      widget.name.toLowerCase(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.normal,
                                        fontSize:
                                            SizeConfig.blockSizeVertical * 1.35,
                                        color: fontColor,
                                        letterSpacing: -0.25,
                                      ),
                                    ),
                                  )
                                ],
                              ))),
          ),
        ));
  }
}
