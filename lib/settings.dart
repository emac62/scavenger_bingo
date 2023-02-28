import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:scavenger_hunt_bingo/data/set_random_list.dart';
import 'package:scavenger_hunt_bingo/game_board.dart';
import 'package:scavenger_hunt_bingo/providers/settings_provider.dart';
import 'package:scavenger_hunt_bingo/widgets/audio.dart';
import 'package:scavenger_hunt_bingo/widgets/banner_ad_widget.dart';
import 'package:scavenger_hunt_bingo/utils/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  var settingsProvider = SettingsProvider();
  late String selectedBoard;
  late String selectedPattern;
  late bool withSound;
  late List<String> selectedList;

  BannerAdContainer bannerAdContainer = BannerAdContainer();

  @override
  void initState() {
    super.initState();
    loadPrefs().then((_) {
      setState(() {
        withSound = withSound;
        selectedBoard = selectedBoard;
        selectedPattern = selectedPattern;
      });
    });
  }

  loadPrefs() async {
    SharedPreferences savedPref = await SharedPreferences.getInstance();
    setState(() {
      withSound = (savedPref.getBool('withSound') ?? true);
      selectedBoard = (savedPref.getString('selectedBoard') ?? "City Walk");
      selectedPattern = (savedPref.getString('selectedPattern') ?? "One Line");
    });
  }

  int cardIndex = 0;
  int winIndex = 0;

  List<String> cards = [
    "City Walk",
    "Trail Walk",
    "Stay Indoors",
    "Family Room",
    "Bedroom",
    "Waiting Room",
    "Virtual Meeting",
    "City with Images",
    "Trail with Images",
    "Indoors with Images",
    "Grocery Store with Images",
    "Classroom with Images",
    "Restaurant with Images",
    "Halloween",
    "Christmas",
  ];

  List<String> toWin = [
    "One Line",
    "Letter X",
    "Full Card",
  ];

  List<Widget> winChips() {
    var settingsProvider = Provider.of<SettingsProvider>(context);
    List<Widget> chips = [];
    for (int i = 0; i < toWin.length; i++) {
      Widget item = Padding(
        padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 1),
        child: ChoiceChip(
          label: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(toWin[i]),
          ),
          labelStyle: TextStyle(
            color: Colors.yellow[50],
            fontSize: SizeConfig.safeBlockHorizontal * 3.5,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
          backgroundColor: Colors.blue,
          selectedColor: Colors.purple,
          selected: settingsProvider.selectedPattern == toWin[i],
          onSelected: (bool value) {
            setState(() {
              winIndex = i;
              selectedPattern = toWin[i];
              settingsProvider.setPattern(selectedPattern);
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
          var settingsProvider = Provider.of<SettingsProvider>(context);
          //Here we will build the content of the dialog
          return AlertDialog(
            backgroundColor: Colors.yellow[50],
            scrollable: true,
            titlePadding: EdgeInsets.only(top: 4),
            contentPadding: EdgeInsets.symmetric(
                vertical: SizeConfig.blockSizeVertical * 3,
                horizontal: SizeConfig.blockSizeHorizontal * 4),
            insetPadding: EdgeInsets.symmetric(
                vertical: SizeConfig.blockSizeVertical * 3,
                horizontal: SizeConfig.blockSizeHorizontal * 4),
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.purple, width: 5.0),
                borderRadius: BorderRadius.all(Radius.circular(25))),
            title: Text(
              "Choose a card:",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.purple,
                fontFamily: 'CaveatBrush',
                fontSize: SizeConfig.safeBlockHorizontal * 10,
              ),
            ),
            content: SingleChildScrollView(
              child: CardSelectChip(
                cards: cards,
                cardIndex: cardIndex,
                selectedBoard: selectedBoard,
                onSelectionChanged: (choice) {
                  setState(() {
                    selectedBoard = choice;
                    settingsProvider.setBoard(selectedBoard);
                  });
                },
              ),
            ),
            actions: <Widget>[],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var settingsProvider = Provider.of<SettingsProvider>(context);
    int gamesStarted = settingsProvider.gamesStarted;
    return Scaffold(
      key: _key,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(SizeConfig.blockSizeHorizontal * 12),
        child: NewGradientAppBar(
          automaticallyImplyLeading: false,
          title: AutoSizeText(
            "Settings",
            style: TextStyle(
                color: Colors.yellow[50],
                fontFamily: 'CaveatBrush',
                fontSize: SizeConfig.safeBlockHorizontal * 10,
                letterSpacing: 2.5),
          ),
          gradient: LinearGradient(colors: [Colors.purple, Colors.blue]),
          actions: [],
        ),
      ),
      body: Container(
        width: SizeConfig.safeBlockHorizontal * 100,
        height: (SizeConfig.safeBlockVertical * 100),
        decoration: BoxDecoration(
            color: Colors.yellow[50],
            border: Border(
              bottom: BorderSide(
                color: Colors.purple,
                width: 3,
              ),
            )),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.blockSizeHorizontal * 8),
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Play sound effects?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.blue,
                          fontFamily: 'CaveatBrush',
                          fontSize: SizeConfig.safeBlockHorizontal * 7,
                        ),
                        maxLines: 1,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          right: SizeConfig.blockSizeHorizontal * 3,
                          top: SizeConfig.blockSizeVertical * 1,
                        ),
                        child: Center(
                          child: Transform.scale(
                            scale: SizeConfig.blockSizeHorizontal * 0.2,
                            child: CupertinoSwitch(
                              value: settingsProvider.withSound,
                              activeColor: Colors.purple,
                              thumbColor: Colors.yellow[50],
                              onChanged: (value) {
                                setState(() {
                                  withSound = value;
                                  settingsProvider.setWithSound(withSound);
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: SizeConfig.blockSizeVertical / 10,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: Text(
                    "Where are you playing?",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.blue,
                      fontFamily: 'CaveatBrush',
                      fontSize: SizeConfig.safeBlockHorizontal * 7,
                    ),
                    maxLines: 1,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.blockSizeVertical * 1,
                      horizontal: SizeConfig.blockSizeHorizontal * 3),
                  child: ElevatedButton(
                      onPressed: () {
                        _showCardDialog();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: SizeConfig.blockSizeVertical * 1,
                            horizontal: SizeConfig.blockSizeHorizontal * 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AutoSizeText(
                              settingsProvider.selectedBoard,
                              style: TextStyle(
                                color: Colors.yellow[50],
                                fontWeight: FontWeight.w600,
                                fontSize: SizeConfig.safeBlockHorizontal * 3.5,
                              ),
                              minFontSize: 0,
                              stepGranularity: 0.1,
                              maxLines: 1,
                            ),
                            Icon(
                              LineAwesomeIcons.angle_double_down,
                              color: Colors.yellow[50],
                              size: SizeConfig.safeBlockHorizontal * 6,
                            ),
                          ],
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.yellow[50],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        backgroundColor: Colors.purple,
                        side: BorderSide(
                          color: Colors.blue,
                          width: 3.0,
                        ),
                        elevation: 10,
                        textStyle: TextStyle(
                            fontSize: SizeConfig.safeBlockHorizontal * 4,
                            fontWeight: FontWeight.bold),
                      )),
                ),
                SizedBox(
                  height: SizeConfig.blockSizeVertical / 10,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: AutoSizeText(
                    "How would you like to win?",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.blue,
                      fontFamily: 'CaveatBrush',
                      fontSize: SizeConfig.safeBlockHorizontal * 7,
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
                  height: SizeConfig.blockSizeVertical / 10,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: AutoSizeText(
                    "Playing with other adults?",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.blue,
                      fontFamily: 'CaveatBrush',
                      fontSize: SizeConfig.safeBlockHorizontal * 7,
                    ),
                    maxLines: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
                  child: AutoSizeText(
                    "Choose the same card and the same way to win. Click 'Share' to send an image of your winning card. Only available for cards without images.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.safeBlockHorizontal * 2.5,
                      letterSpacing: -0.8,
                    ),
                  ),
                ),
                Container(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.blockSizeVertical * 3),
                      child: ElevatedButton(
                          onPressed: () {
                            if (withSound) playSound('magicalSlice2.mp3');

                            settingsProvider.setGamesStarted(gamesStarted++);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => GameBoard()),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text("Play Bingo"),
                          ),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.yellow[50],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            backgroundColor: Colors.purple,
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
    var settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
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

              settingsProvider.setBoard(widget.cards[i]);

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
