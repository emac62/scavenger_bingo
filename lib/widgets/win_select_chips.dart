import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/controller.dart';
import '../providers/settings_provider.dart';
import '../utils/size_config.dart';

class WinSelectChips extends StatefulWidget {
  const WinSelectChips({Key? key, required this.toWin}) : super(key: key);
  final List<String> toWin;

  @override
  State<WinSelectChips> createState() => _WinSelectChipsState();
}

class _WinSelectChipsState extends State<WinSelectChips> {
  List<Widget> winChips() {
    var settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    var cont = Provider.of<Controller>(context, listen: false);

    List<Widget> chips = [];
    for (int i = 0; i < widget.toWin.length; i++) {
      Widget item = Padding(
        padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 1),
        child: ChoiceChip(
          label: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(widget.toWin[i]),
          ),
          labelStyle: TextStyle(
            color: Colors.yellow[50],
            fontSize: SizeConfig.screenWidth < 400
                ? SizeConfig.safeBlockVertical * 2.25
                : SizeConfig.safeBlockVertical * 2.5,
            fontFamily: "CaveatBrush",
            letterSpacing: -0.5,
          ),
          backgroundColor: Colors.blue,
          selectedColor: Colors.purple,
          selected: settingsProvider.selectedPattern == widget.toWin[i],
          onSelected: (bool selected) {
            if (selected) {
              setState(() {
                settingsProvider.setPattern(widget.toWin[i]);
                cont.setWinningPattern(widget.toWin[i]);
              });
            }
          },
        ),
      );
      chips.add(item);
    }
    return chips;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
        spacing: 3,
        direction: Axis.horizontal,
        alignment: WrapAlignment.center,
        children: winChips());
  }
}
