import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:scavenger_hunt_bingo/game_board.dart';
import 'package:scavenger_hunt_bingo/widgets/ad_helper.dart';
import 'package:scavenger_hunt_bingo/widgets/audio.dart';

const int maxFailedLoadAttempts = 3;

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

  late BannerAd _bannerAd;
  bool _isBannerAdReady = false;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
        // Change Banner Size According to Ur Need
        size: AdSize.banner,
        adUnitId: AdHelper.bannerAdUnitId,
        listener: BannerAdListener(onAdLoaded: (_) {
          setState(() {
            _isBannerAdReady = true;
          });
        }, onAdFailedToLoad: (ad, LoadAdError error) {
          print("Failed to Load Banner Ad: ${error.message}");
          _isBannerAdReady = false;
          ad.dispose();
        }),
        request: AdRequest())
      ..load();
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd.dispose();
  }

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
              child: AutoSizeText(
                "Where are you playing?",
                style:
                    TextStyle(color: Colors.purple, fontFamily: 'CaveatBrush'),
                minFontSize: 30,
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
                style:
                    TextStyle(color: Colors.purple, fontFamily: 'CaveatBrush'),
                minFontSize: 30,
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
                    textStyle:
                        TextStyle(fontSize: 30, fontFamily: 'CaveatBrush')),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: (_isBannerAdReady)
          ? Container(
              height: _bannerAd.size.height.toDouble(),
              width: _bannerAd.size.width.toDouble(),
              child: AdWidget(ad: _bannerAd),
            )
          : Container(
              height: 50,
              color: Colors.yellow[50],
            ),
    );
  }

  List<Widget> cardChips() {
    List<Widget> chips = [];
    for (int i = 0; i < cards.length; i++) {
      Widget item = Padding(
        padding: const EdgeInsets.only(left: 10, right: 5),
        child: ChoiceChip(
          label: Text(cards[i]),
          labelStyle: TextStyle(color: Colors.yellow[50], fontSize: 12),
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
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: ChoiceChip(
          label: Text(toWin[i]),
          labelStyle: TextStyle(color: Colors.yellow[50], fontSize: 12),
          backgroundColor: Colors.blue,
          selectedColor: Colors.purple,
          selected: winIndex == i,
          onSelected: (bool value) {
            setState(() {
              winIndex = i;
              selectedPattern = toWin[i];
              print("Play Button: $selectedPattern");
            });
          },
        ),
      );
      chips.add(item);
    }
    return chips;
  }
}
