import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:scavenger_hunt_bingo/game_board.dart';
import 'package:scavenger_hunt_bingo/widgets/audio.dart';
import 'package:scavenger_hunt_bingo/widgets/banner_ad_widget.dart';
import 'package:scavenger_hunt_bingo/widgets/size_config.dart';

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
    "Trail Walk",
    "Stay Indoors",
    "City with Images",
    "Trail with Images",
    "Indoors with Images",
    "Grocery Store with Images",
    "Classroom with Images",
  ];

  List<String> toWin = [
    "One Line",
    "Letter X",
    "Full Card",
  ];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: _key,
      appBar: NewGradientAppBar(
        automaticallyImplyLeading: false,
        title: AutoSizeText(
          "Settings",
          style: TextStyle(
              color: Colors.yellow[50],
              fontFamily: 'CaveatBrush',
              fontSize: SizeConfig.safeBlockHorizontal * 12,
              letterSpacing: 2.5),
        ),
        gradient: LinearGradient(colors: [Colors.purple, Colors.blue]),
        actions: [],
      ),
      body: Container(
        width: double.infinity,
        color: Colors.yellow[50],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
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
                  fontSize: SizeConfig.safeBlockHorizontal * 10,
                ),
                maxLines: 1,
              ),
            ),
            Wrap(
                spacing: 3,
                direction: Axis.horizontal,
                alignment: WrapAlignment.center,
                children: cardChips()),
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
                  fontSize: SizeConfig.safeBlockHorizontal * 9,
                ),
                maxLines: 1,
              ),
            ),
            Wrap(
                spacing: 3,
                direction: Axis.horizontal,
                alignment: WrapAlignment.center,
                children: winChips()),
            Expanded(
              child: Container(
                child: Center(
                  child: Padding(
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
                            fontFamily: 'CaveatBrush',
                            fontSize: SizeConfig.safeBlockHorizontal * 10,
                          ),
                        )),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: bannerAdContainer,
    );
  }

  List<Widget> cardChips() {
    List<Widget> chips = [];
    for (int i = 0; i < cards.length; i++) {
      Widget item = Padding(
        padding: const EdgeInsets.all(2),
        child: ChoiceChip(
          label: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(cards[i]),
          ),
          labelStyle: TextStyle(
            color: Colors.yellow[50],
            fontSize: SizeConfig.safeBlockHorizontal * 3.5,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
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
    List<Widget> chips = [];
    for (int i = 0; i < toWin.length; i++) {
      Widget item = Padding(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(toWin[i]),
          ),
          labelStyle: TextStyle(
              color: Colors.yellow[50],
              fontSize: SizeConfig.safeBlockHorizontal * 4,
              fontWeight: FontWeight.bold),
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
