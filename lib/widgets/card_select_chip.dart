import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scavenger_hunt_bingo/data/set_random_list.dart';

import '../providers/settings_provider.dart';
import '../utils/size_config.dart';

class CardSelectChip extends StatefulWidget {
  CardSelectChip({
    Key? key,
    required this.cards,
    required this.selectedBoard,
  }) : super(key: key);
  final List<String> cards;
  final String selectedBoard;

  @override
  _CardSelectChipState createState() => _CardSelectChipState();
}

class _CardSelectChipState extends State<CardSelectChip> {
  List<Widget> cardChips() {
    var settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    List<Widget> chips = [];
    String choice = widget.selectedBoard;
    for (int i = 0; i < widget.cards.length; i++) {
      Widget item = Padding(
        padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 1),
        child: ChoiceChip(
          showCheckmark: false,
          label: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(widget.cards[i]),
          ),
          labelStyle: TextStyle(
            color: Colors.yellow[50],
            fontSize: SizeConfig.screenWidth < 400
                ? SizeConfig.safeBlockVertical * 1.75
                : SizeConfig.safeBlockVertical * 3,
            // fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
          backgroundColor: Colors.blue,
          selectedColor: Colors.purple,
          selected: widget.cards[i] == widget.selectedBoard,
          onSelected: (bool selected) {
            if (widget.cards[i] != widget.selectedBoard) {
              if (selected) {
                choice = widget.cards[i];
                settingsProvider.setBoard(choice);

                setRandomList(context, choice);

                Navigator.of(context).pop();
              }
            } else {
              Navigator.of(context).pop();
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
      children: cardChips(),
    );
  }
}
