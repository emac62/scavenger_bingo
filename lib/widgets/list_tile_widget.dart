import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scavenger_hunt_bingo/utils/size_config.dart';
import 'package:scavenger_hunt_bingo/widgets/winning_dialog.dart';
import 'package:screenshot/screenshot.dart';

import '../providers/controller.dart';
import '../providers/settings_provider.dart';
import 'audio.dart';

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
  // List winPattern = [];

  var gameSounds = GameSounds();

  @override
  void dispose() {
    gameSounds.disposeGameSound();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var cont = Provider.of<Controller>(context);
    var settingsProvider = Provider.of<SettingsProvider>(context);
    var fontColor = cont.gameWon && cont.winPattern.contains(widget.index)
        ? Colors.blue[50]
        : isSelected
            ? Colors.blue[100]
            : Colors.purple;
    return GestureDetector(
        onTap: () {
          if (settingsProvider.withSound) gameSounds.stopGameSound();
          if (!cont.disableTiles) {
            setState(() {
              if (isSelected) {
                isSelected = !isSelected;
                cont.removeFromSelectedTiles(widget.index);
              } else {
                isSelected = !isSelected;
                if (settingsProvider.withSound) gameSounds.playWoosh();
                cont.addToSelectedTiles(widget.index);
              }
            });
            cont.checkForWinner();
            if (cont.gameWon) {
              settingsProvider.setGamesWon(settingsProvider.gamesWon + 1);
              int gamesForAd =
                  settingsProvider.gamesWon + settingsProvider.gamesStarted;
              Future.delayed(Duration(milliseconds: 2000), () {
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (_, __, ___) => WinningDialog(
                        screenshotController: widget.screenshotController,
                        gamesForAd: gamesForAd)));
              });
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
                  color: cont.gameWon && cont.winPattern.contains(widget.index)
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
                                fontWeight: cont.gameWon &&
                                        cont.winPattern.contains(widget.index)
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
