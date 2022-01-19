import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:scavenger_hunt_bingo/game_board.dart';
import 'package:scavenger_hunt_bingo/widgets/audio.dart';
import 'package:scavenger_hunt_bingo/widgets/banner_ad_widget.dart';
import 'package:scavenger_hunt_bingo/widgets/size_config.dart';

// ignore: must_be_immutable
class SettingsPage extends StatefulWidget {
  bool withSound;
  SettingsPage({Key? key, required this.withSound}) : super(key: key);

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
    "Waiting Room",
    "Virtual Meeting",
    "City with Images",
    "Trail with Images",
    "Indoors with Images",
    "Grocery Store with Images",
    "Classroom with Images",
    "Restaurant with Images",
  ];

  List<String> toWin = [
    "One Line",
    "Letter X",
    "Full Card",
  ];

  List<Widget> winChips() {
    List<Widget> chips = [];
    for (int i = 0; i < toWin.length; i++) {
      Widget item = Padding(
        padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 1),
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

  _showCardDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //Here we will build the content of the dialog
          return AlertDialog(
            backgroundColor: Colors.yellow[50],
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.purple, width: 5.0),
                borderRadius: BorderRadius.all(Radius.circular(25))),
            title: Text(
              "Choose a card:",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.purple,
                fontFamily: 'CaveatBrush',
                fontSize: SizeConfig.safeBlockHorizontal * 8,
              ),
            ),
            content: Container(
              child: SingleChildScrollView(
                child: CardSelectChip(
                  cards: cards,
                  cardIndex: cardIndex,
                  selectedBoard: selectedBoard,
                  onSelectionChanged: (choice) {
                    setState(() {
                      selectedBoard = choice;
                    });
                  },
                ),
              ),
            ),
            actions: <Widget>[],
          );
        });
  }

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
              fontSize: SizeConfig.safeBlockHorizontal * 15,
              letterSpacing: 2.5),
        ),
        gradient: LinearGradient(colors: [Colors.purple, Colors.blue]),
        actions: [],
      ),
      body: Container(
        width: SizeConfig.safeBlockHorizontal * 100,
        height: SizeConfig.safeBlockVertical * 100,
        color: Colors.yellow[50],
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Play with sound effects?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.purple,
                      fontFamily: 'CaveatBrush',
                      fontSize: SizeConfig.safeBlockHorizontal * 8,
                    ),
                    maxLines: 1,
                  ),
                  CupertinoSwitch(
                    value: widget.withSound,
                    activeColor: Colors.purple,
                    thumbColor: Colors.blue,
                    onChanged: (value) {
                      setState(() {
                        widget.withSound = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Where are you playing?",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.purple,
                  fontFamily: 'CaveatBrush',
                  fontSize: SizeConfig.safeBlockHorizontal * 8,
                ),
                maxLines: 1,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    _showCardDialog();
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4.0, 10.0, 4.0, 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AutoSizeText(
                          selectedBoard,
                          maxFontSize: 20,
                        ),
                        Icon(
                          Icons.read_more,
                          color: Colors.yellow[50],
                        )
                      ],
                    ),
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
                    elevation: 10,
                    textStyle: TextStyle(
                        fontSize: SizeConfig.safeBlockHorizontal * 6,
                        fontWeight: FontWeight.bold),
                  )),
            ),
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AutoSizeText(
                "How would you like to win?",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.purple,
                  fontFamily: 'CaveatBrush',
                  fontSize: SizeConfig.safeBlockHorizontal * 8,
                ),
                maxLines: 1,
              ),
            ),
            Wrap(
                spacing: 3,
                direction: Axis.horizontal,
                alignment: WrapAlignment.center,
                children: winChips()),
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AutoSizeText(
                "Playing with others?",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.purple,
                  fontFamily: 'CaveatBrush',
                  fontSize: SizeConfig.safeBlockHorizontal * 8,
                ),
                maxLines: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AutoSizeText(
                "If you get a winning BINGO, click the Share button to copy the game board to the device clipboard. It will be saved with the date and time in the title and can be pasted anywhere as an image.",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: SizeConfig.safeBlockHorizontal * 4,
                ),
              ),
            ),
            Container(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                  child: ElevatedButton(
                      onPressed: () {
                        if (widget.withSound) playSound('magicalSlice2.mp3');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GameBoard(
                                    selectedBoard: selectedBoard,
                                    selectedPattern: selectedPattern,
                                    withSound: widget.withSound,
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
          ],
        ),
      ),
      bottomNavigationBar: bannerAdContainer,
    );
  }
}

// ignore: must_be_immutable
class CardSelectChip extends StatefulWidget {
  final List<String> cards;
  int cardIndex;
  String selectedBoard;
  Function onSelectionChanged;

  CardSelectChip(
      {Key? key,
      required this.cards,
      required this.cardIndex,
      required this.selectedBoard,
      required this.onSelectionChanged})
      : super(key: key);

  @override
  _CardSelectChipState createState() => _CardSelectChipState();
}

class _CardSelectChipState extends State<CardSelectChip> {
  List<Widget> cardChips() {
    List<Widget> chips = [];
    var choice = widget.selectedBoard;
    for (int i = 0; i < widget.cards.length; i++) {
      Widget item = Padding(
        padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 1),
        child: ChoiceChip(
          label: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(widget.cards[i]),
          ),
          labelStyle: TextStyle(
            color: Colors.yellow[50],
            fontSize: SizeConfig.safeBlockHorizontal * 3.5,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
          backgroundColor: Colors.blue,
          selectedColor: Colors.purple,
          selected: widget.cardIndex == i,
          onSelected: (bool value) {
            setState(() {
              widget.cardIndex = i;
              choice = widget.cards[i];
              widget.onSelectionChanged(choice);
              Navigator.of(context).pop();
            });
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
