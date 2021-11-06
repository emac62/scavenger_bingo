import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:scavenger_hunt_bingo/game_board.dart';
import 'package:scavenger_hunt_bingo/widgets/audio.dart';
import 'package:scavenger_hunt_bingo/widgets/banner_ad_widget.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    Key? key,
  }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  String selectedBoard = 'City Walk';
  String selectedPattern = 'One Line';

  BannerAdContainer bannerAdContainer = BannerAdContainer();

  int cardIndex = 0;
  int winIndex = 0;

  List<String> cards = [
    "City Walk",
    "City Walk with Images",
    "Trail Walk",
    "Trail Walk with Images",
    "Stay Indoors",
    "Stay Indoors with Images",
    "Grocery Store with Images",
    "Classroom with Images",
  ];

  List<String> toWin = [
    "One Line",
    "Cross",
    "Full Card",
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      key: _key,
      appBar: NewGradientAppBar(
        automaticallyImplyLeading: false,
        title: AutoSizeText(
          "Settings",
          style: TextStyle(
              color: Colors.yellow[50],
              fontFamily: 'CaveatBrush',
              fontSize: size.width,
              letterSpacing: 2.0),
        ),
        gradient: LinearGradient(colors: [Colors.purple, Colors.blue]),
        actions: [],
      ),
      body: Container(
        width: double.infinity,
        color: Colors.yellow[50],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                "Where are you playing?",
                style: TextStyle(
                    color: Colors.purple,
                    fontFamily: 'CaveatBrush',
                    fontSize: size.width * 0.075),
                maxLines: 1,
              ),
            ),
            Wrap(spacing: 3, direction: Axis.horizontal, children: cardChips()),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: AutoSizeText(
                "How would you like to win?",
                style: TextStyle(
                    color: Colors.purple,
                    fontFamily: 'CaveatBrush',
                    fontSize: size.width * 0.075),
                maxLines: 1,
              ),
            ),
            Wrap(spacing: 3, direction: Axis.horizontal, children: winChips()),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
              child: ElevatedButton(
                  onPressed: () {
                    playSound('magicalSlice2.mp3');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GameBoard(
                                selectedBoard: selectedBoard,
                                selectedPattern: selectedPattern,
                              )),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text("Play Bingo"),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    primary: Colors.purple,
                    onPrimary: Colors.yellow[50],
                    side: BorderSide(
                      color: Colors.blue,
                      width: 3.0,
                    ),
                    elevation: 20,
                    textStyle: TextStyle(
                        fontFamily: 'CaveatBrush', fontSize: size.width * 0.1),
                  )),
            ),
          ],
        ),
      ),
      bottomNavigationBar: bannerAdContainer,
    );
  }

  List<Widget> cardChips() {
    var size = MediaQuery.of(context).size;
    List<Widget> chips = [];
    for (int i = 0; i < cards.length; i++) {
      Widget item = Padding(
        padding: const EdgeInsets.all(4),
        child: ChoiceChip(
          label: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(cards[i]),
          ),
          labelStyle:
              TextStyle(color: Colors.yellow[50], fontSize: size.width * 0.04),
          backgroundColor: Colors.blue,
          selectedColor: Colors.purple,
          selected: cardIndex == i,
          onSelected: (bool value) {
            setState(() {
              cardIndex = i;
              selectedBoard = cards[i];
            });
          },
        ),
      );
      chips.add(item);
    }
    return chips;
  }

  List<Widget> winChips() {
    var size = MediaQuery.of(context).size;
    List<Widget> chips = [];
    for (int i = 0; i < toWin.length; i++) {
      Widget item = Padding(
        padding: const EdgeInsets.all(4),
        child: ChoiceChip(
          label: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(toWin[i]),
          ),
          labelStyle:
              TextStyle(color: Colors.yellow[50], fontSize: size.width * 0.04),
          backgroundColor: Colors.blue,
          selectedColor: Colors.purple,
          selected: winIndex == i,
          onSelected: (bool value) {
            setState(() {
              winIndex = i;
              selectedPattern = toWin[i];
            });
          },
        ),
      );
      chips.add(item);
    }
    return chips;
  }
}
