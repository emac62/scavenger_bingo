import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:rate_my_app/rate_my_app.dart';

import 'package:provider/provider.dart';
import 'package:scavenger_hunt_bingo/data/bingo_card.dart';
import 'package:scavenger_hunt_bingo/data/set_random_list.dart';
import 'package:scavenger_hunt_bingo/pages/game_board.dart';
import 'package:scavenger_hunt_bingo/providers/settings_provider.dart';
import 'package:scavenger_hunt_bingo/pages/text_cards.dart';
import 'package:scavenger_hunt_bingo/utils/audio.dart';
import 'package:scavenger_hunt_bingo/widgets/banner_ad_widget.dart';
import 'package:scavenger_hunt_bingo/utils/size_config.dart';

import 'package:scavenger_hunt_bingo/widgets/paywall.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/main.dart';
import '../providers/controller.dart';

// ignore: must_be_immutable
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var settingsProvider = SettingsProvider();
  late String selectedBoard;
  late String selectedPattern;
  late bool withSound;

  int games = 0;

  List<String> textCards = [];
  List<String> imageCards = [];
  Box cardBox = Hive.box<BingoCard>('cards');

  var gameSounds = GameSounds();

  separateCards() {
    for (var i = 0; i < cardBox.length; i++) {
      final bingoCard = cardBox.get(i) as BingoCard;
      if (bingoCard.name.contains("Images")) {
        imageCards.add(bingoCard.name);
      } else {
        if (bingoCard.name != "Create My Own") {
          textCards.add(bingoCard.name);
        }
      }
    }
  }
  // late List<String> selectedList;

  BannerAdContainer bannerAdContainer = BannerAdContainer();
  final RateMyApp rateMyApp = RateMyApp(
      preferencesPrefix: "rateMyApp_",
      appStoreIdentifier: 'com.blB.savengerHuntBingo',
      googlePlayIdentifier: 'com.blB.savenger_hunt_bingo',
      minDays: 3,
      minLaunches: 5,
      remindDays: 7,
      remindLaunches: 10);

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
    separateCards();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await rateMyApp.init();

      if (mounted && rateMyApp.shouldOpenDialog && games > 5) {
        rateMyApp.showStarRateDialog(
          context,
          title: "Enjoying Bingo?",
          message: "Please consider leaving a rating.",
          starRatingOptions: const StarRatingOptions(initialRating: 4),
          dialogStyle: const DialogStyle(
              titleAlign: TextAlign.center,
              messageAlign: TextAlign.center,
              messagePadding: EdgeInsets.only(bottom: 20)),
          actionsBuilder: (context, stars) {
            return [
              RateMyAppNoButton(rateMyApp, text: "CANCEL"),
              TextButton(
                onPressed: () async {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Thanks for your feedback!')),
                  );
                  final launchAppStore = stars! >= 4;

                  const event = RateMyAppEventType.rateButtonPressed;

                  await rateMyApp.callEvent(event);

                  if (launchAppStore) {
                    rateMyApp.launchStore();
                  }
                  if (!mounted) return;
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              )
            ];
          },
          onDismissed: () =>
              rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
        );
      }
    });
  }

  loadPrefs() async {
    SharedPreferences savedPref = await SharedPreferences.getInstance();
    setState(() {
      games = (savedPref.getInt('gamesWon') ?? 0) +
          (savedPref.getInt('gamesStarted') ?? 0);
      withSound = (savedPref.getBool('withSound') ?? true);
      selectedBoard = (savedPref.getString('selectedBoard') ?? "City Walk");
      selectedPattern = (savedPref.getString('selectedPattern') ?? "One Line");
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  double getFontSize() {
    double fontSize = 0;
    fontSize = SizeConfig.screenWidth < 500 || SizeConfig.screenHeight < 700
        ? SizeConfig.safeBlockVertical * 2
        : SizeConfig.safeBlockVertical * 2.5;
    return fontSize;
  }

  int cardIndex = 0;
  int winIndex = 0;

  List<String> toWin = [
    "One Line",
    "Letter X",
    "Full Card",
  ];

  List<Widget> winChips() {
    var settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    var cont = Provider.of<Controller>(context, listen: false);
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
            fontSize: SizeConfig.screenWidth < 400
                ? SizeConfig.safeBlockVertical * 2.25
                : SizeConfig.safeBlockVertical * 2.5,
            fontFamily: "CaveatBrush",
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
              cont.setWinningPattern(selectedPattern);
            });
          },
        ),
      );
      chips.add(item);
    }
    return chips;
  }

  _showCardDialog(BuildContext context, List<String> cards) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          var settingsProvider =
              Provider.of<SettingsProvider>(context, listen: false);

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

                    setRandomList(context, selectedBoard);
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

    var settingsProvider = Provider.of<SettingsProvider>(context, listen: true);
    var cont = Provider.of<Controller>(context, listen: true);
    int gamesStarted = settingsProvider.gamesStarted;
    getFontSize();
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Settings",
          style: TextStyle(
              color: Colors.yellow[50],
              fontFamily: 'CaveatBrush',
              fontSize: SizeConfig.blockSizeVertical * 5,
              letterSpacing: 2.5),
        ),
        toolbarHeight: SizeConfig.blockSizeVertical * 6.5,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.purple, Colors.blue],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight),
          ),
        ),
        actions: [],
      ),
      body: SafeArea(
        child: Container(
          width: SizeConfig.safeBlockHorizontal * 100,
          height: (SizeConfig.safeBlockVertical * 100),
          decoration: BoxDecoration(
              color: Colors.yellow[50],
              border: Border(
                bottom: BorderSide(
                  color: settingsProvider.removeAds
                      ? Colors.transparent
                      : Colors.purple,
                  width: 3,
                ),
              )),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.isPhone
                    ? SizeConfig.blockSizeHorizontal * 3
                    : SizeConfig.blockSizeHorizontal * 8),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Play sound effects?",
                      style: TextStyle(
                        color: Colors.blue,
                        fontFamily: 'CaveatBrush',
                        fontSize: SizeConfig.screenWidth > 600
                            ? SizeConfig.safeBlockVertical * 3.5
                            : SizeConfig.safeBlockVertical * 3,
                      ),
                      maxLines: 1,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.transparent)),
                      child: Transform.scale(
                        scale: SizeConfig.blockSizeVertical * 0.09,
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
                  ],
                ),
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 1,
                ),
                Text(
                  "Choose your card:",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Colors.blue,
                    fontFamily: 'CaveatBrush',
                    fontSize: SizeConfig.screenWidth > 600
                        ? SizeConfig.safeBlockVertical * 3.5
                        : SizeConfig.safeBlockVertical * 3,
                  ),
                  maxLines: 1,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: SizeConfig.blockSizeVertical * 1,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      PurpleBtn(
                          name: "Text Only",
                          font: "Roboto",
                          onPressed: (() {
                            setState(() {
                              _showCardDialog(context, textCards);
                            });
                          }),
                          fontSize: getFontSize()),
                      PurpleBtn(
                          name: "Text and Images",
                          font: "Roboto",
                          onPressed: (() {
                            setState(() {
                              _showCardDialog(context, imageCards);
                            });
                          }),
                          fontSize: getFontSize())
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      PurpleBtn(
                        name: "Create A Text Card",
                        font: "Roboto",
                        fontSize: getFontSize(),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TextCards()),
                          );
                        },
                      ),
                      PurpleBtn(
                          name: "Edit a Text Card",
                          font: "Roboto",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TextCards()),
                            );
                          },
                          fontSize: getFontSize()),
                    ],
                  ),
                ),
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 1,
                ),
                Text(
                  "Current Card:",
                  style: TextStyle(
                    color: Colors.blue,
                    fontFamily: 'CaveatBrush',
                    fontSize: SizeConfig.screenWidth > 600
                        ? SizeConfig.safeBlockVertical * 3.5
                        : SizeConfig.safeBlockVertical * 3,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.blockSizeHorizontal * 1,
                        horizontal: SizeConfig.blockSizeHorizontal * 2),
                    child: Text(
                      settingsProvider.selectedBoard,

                      style: TextStyle(
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.screenWidth < 400
                            ? SizeConfig.safeBlockVertical * 3
                            : SizeConfig.safeBlockVertical * 2.5,
                      ),
                      // maxLines: 1,
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.blockSizeVertical * 1,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Text(
                    "How would you like to win?",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.blue,
                      fontFamily: 'CaveatBrush',
                      fontSize: SizeConfig.screenWidth > 600
                          ? SizeConfig.safeBlockVertical * 3.5
                          : SizeConfig.safeBlockVertical * 3,
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
                  child: Text(
                    "Playing with other adults?",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Colors.blue,
                      fontFamily: 'CaveatBrush',
                      fontSize: SizeConfig.screenWidth > 600
                          ? SizeConfig.safeBlockVertical * 3.5
                          : SizeConfig.safeBlockVertical * 3.5,
                    ),
                    maxLines: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
                  child: Text(
                    "Choose the same location (without images) and the same way to win. Click 'Share' to send an image of your winning card.",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      color: Colors.purple,
                      fontFamily: "Roboto",
                      fontSize: SizeConfig.safeBlockVertical * 1.5,
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.blockSizeVertical / 10,
                ),
                settingsProvider.removeAds
                    ? SizedBox()
                    : Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Remove Ads?",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.blue,
                                fontFamily: 'CaveatBrush',
                                fontSize: SizeConfig.screenWidth > 600
                                    ? SizeConfig.safeBlockVertical * 3.5
                                    : SizeConfig.safeBlockVertical * 3.5,
                              ),
                              maxLines: 1,
                            ),
                            SizedBox(
                              width: SizeConfig.blockSizeHorizontal * 4,
                            ),
                            PurpleBtn(
                                name: "Options",
                                font: "Roboto",
                                onPressed: () {
                                  fetchOffers(context);
                                },
                                fontSize: getFontSize()),
                          ],
                        ),
                      ),
                Expanded(
                  child: Container(
                    child: Center(
                      child: PurpleBtn(
                        name: "Play Bingo",
                        font: 'CaveatBrush',
                        onPressed: () {
                          if (withSound) gameSounds.playMagicalSlice();
                          setState(() {
                            gamesStarted++;
                            settingsProvider.setGamesStarted(gamesStarted);
                            cont.resetWinPattern();
                            // selectedList = [];
                            cont.setDisableTiles(false);
                          });
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GameBoard()),
                          );
                        },
                        fontSize: SizeConfig.screenWidth > 600
                            ? SizeConfig.safeBlockVertical * 5
                            : SizeConfig.safeBlockVertical * 4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: settingsProvider.removeAds
          ? null
          : showBannerAd
              ? bannerAdContainer
              : null,
    );
  }

  Future fetchOffers(context) async {
    final offerings = await Purchases.getOfferings();

    if (offerings.current == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("No Options Found")));
    } else {
      final packages = offerings.current!.availablePackages;
      debugPrint("settings-> fetchOffers: ${packages.length}");
      if (!mounted) return;
      showModalBottomSheet(
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25))),
          context: context,
          builder: (context) => PaywallWidget(
                index: 0,
                packages: packages,
                title: 'Go Ad Free!',
                description: '',
                onClickedPackage: (package) async {
                  try {
                    CustomerInfo customerInfo =
                        await Purchases.purchasePackage(package);

                    if (customerInfo.entitlements.all['no_ads']!.isActive) {
                      if (!mounted) return;
                      removeAds(context);
                    }
                  } catch (e) {
                    debugPrint("Failed to purchase product. $e");
                  }
                  if (!mounted) return;
                  Navigator.pop(context);
                },
              ));
    }
  }

  void removeAds(BuildContext context) {
    var settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    settingsProvider.setRemoveAds(true);
  }

  List<Widget> actionsBuilder(BuildContext context, double? stars) =>
      stars == null
          ? [buildCancelButton()]
          : [buildOkButton(stars), buildCancelButton()];

  Widget buildOkButton(double stars) => TextButton(
        child: const Text('OK'),
        onPressed: () async {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Thanks for your feedback!')),
          );

          final launchAppStore = stars >= 4;

          const event = RateMyAppEventType.rateButtonPressed;

          await rateMyApp.callEvent(event);

          if (launchAppStore) {
            rateMyApp.launchStore();
          }

          if (mounted) {
            Navigator.of(context).pop();
          }
        },
      );

  Widget buildCancelButton() => RateMyAppNoButton(
        rateMyApp,
        text: 'CANCEL',
      );
}

class PurpleBtn extends StatelessWidget {
  const PurpleBtn({
    Key? key,
    required this.name,
    required this.font,
    required this.onPressed,
    required this.fontSize,
  }) : super(key: key);
  final String name;
  final String font;
  final VoidCallback onPressed;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ElevatedButton(
        onPressed: onPressed,
        child: Padding(
          padding: SizeConfig.isPhone
              ? EdgeInsets.symmetric(horizontal: 8, vertical: 6)
              : EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(name),
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.yellow[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.purple,
          side: BorderSide(
            color: Colors.blue,
            width: 2.0,
          ),
          elevation: 10,
          textStyle: TextStyle(
              fontFamily: font,
              fontWeight:
                  name == "Play Bingo" ? FontWeight.normal : FontWeight.bold,
              fontSize: fontSize),
        ));
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
            fontSize: SizeConfig.screenWidth < 400
                ? SizeConfig.safeBlockVertical * 1.75
                : SizeConfig.safeBlockVertical * 3,
            // fontWeight: FontWeight.bold,
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
