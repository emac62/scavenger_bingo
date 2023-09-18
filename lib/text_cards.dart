import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:scavenger_hunt_bingo/data/bingo_card.dart';
import 'package:scavenger_hunt_bingo/providers/settings_provider.dart';
import 'package:scavenger_hunt_bingo/settings.dart';

import 'edit_list.dart';
import 'main.dart';
import 'utils/size_config.dart';
import 'widgets/ad_helper.dart';
import 'widgets/banner_ad_widget.dart';

class TextCards extends StatefulWidget {
  const TextCards({Key? key}) : super(key: key);

  @override
  State<TextCards> createState() => _TextCardsState();
}

class _TextCardsState extends State<TextCards> {
  late InterstitialAd interstitialAd;
  bool isInterstitialAdReady = false;
  BannerAdContainer bannerAdContainer = BannerAdContainer();
  void loadInterstitialAd() {
    InterstitialAd.load(
        adUnitId: useTestAds
            ? AdHelper.testInterstitialAdUnitId
            : AdHelper.interstitialAdUnitId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
          this.interstitialAd = ad;
          isInterstitialAdReady = true;
        }, onAdFailedToLoad: (LoadAdError error) {
          debugPrint("Failed to Load Interstitial Ad ${error.message}");
        })); //Interstitial Ads
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadInterstitialAd();
    getTextCards();
  }

  final cardBox = Hive.box<BingoCard>('cards');
  final List<String> textCards = [];
  getTextCards() {
    for (var i = 0; i < cardBox.length; i++) {
      final bingoCard = cardBox.get(i) as BingoCard;

      if (!bingoCard.name.contains("Images")) {
        textCards.add(bingoCard.name);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var settingsProvider = Provider.of<SettingsProvider>(context, listen: true);
    debugPrint("Available Cards page: ${settingsProvider.purchasedCards}");
    return Scaffold(
        backgroundColor: Colors.yellow[50],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Available Cards",
            style: TextStyle(
              color: Colors.yellow[50],
              fontFamily: 'CaveatBrush',
              fontSize: SizeConfig.blockSizeVertical * 5,
            ),
          ),
          toolbarHeight: SizeConfig.blockSizeVertical * 7,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.purple, Colors.blue],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight),
            ),
          ),
          actions: [
            Padding(
              padding:
                  EdgeInsets.only(right: SizeConfig.blockSizeHorizontal * 3),
              child: IconButton(
                icon: Icon(
                  Icons.settings,
                  size: SizeConfig.blockSizeHorizontal * 4,
                  color: Colors.yellow[50],
                ),
                onPressed: () {
                  if (!settingsProvider.removeAds) {
                    if ((settingsProvider.gamesWon +
                                settingsProvider.gamesStarted) %
                            2 ==
                        0) {
                      if (isInterstitialAdReady) interstitialAd.show();
                    }
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                },
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: _buildListView(),
            )
          ],
        ),
        bottomNavigationBar: settingsProvider.removeAds
            ? null
            : showBannerAd
                ? Container(
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(color: Colors.purple, width: 2))),
                    child: bannerAdContainer)
                : null);
  }

  _buildListView() {
    var settingsProv = Provider.of<SettingsProvider>(context, listen: true);
    return Scrollbar(
      child: ListView.builder(
          itemCount: textCards.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockSizeHorizontal * 5,
                  vertical: SizeConfig.blockSizeVertical * 0.5),
              child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.blockSizeHorizontal * 8,
                      vertical: 0),
                  tileColor: Colors.yellow[50],
                  dense: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(color: Colors.blue, width: 2)),
                  title: Text(
                    textCards[index],
                    style: TextStyle(
                        color: Colors.purple,
                        fontFamily: "CaveatBrush",
                        fontSize: SizeConfig.blockSizeVertical * 2.5),
                  ),
                  trailing:
                      settingsProv.purchasedCards.contains(textCards[index])
                          ? Icon(
                              Icons.play_arrow,
                              color: Colors.purple,
                              size: SizeConfig.blockSizeVertical * 2,
                            )
                          : Icon(
                              Icons.lock,
                              color: Colors.purple,
                              size: SizeConfig.blockSizeVertical * 2,
                            ),
                  onTap: () {
                    settingsProv.purchasedCards.contains(textCards[index])
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditList(name: textCards[index])))
                        : showPurchaseOptions(context, textCards[index], index);
                  }),
            );
            //         );
          }),
    );
  }

  showPurchaseOptions(BuildContext context, String name, int index) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        context: context,
        builder: (context) {
          var settingsProv =
              Provider.of<SettingsProvider>(context, listen: true);
          return Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 3),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25)),
                  color: Colors.yellow[50]),
              constraints: SizeConfig.screenHeight > 750
                  ? BoxConstraints(maxHeight: SizeConfig.blockSizeVertical * 50)
                  : BoxConstraints(
                      maxHeight: SizeConfig.blockSizeVertical * 75),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.blue, width: 2),
                    color: Colors.yellow[50]),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Text(
                        "Purchase this Card",
                        style: TextStyle(
                            fontSize: SizeConfig.blockSizeVertical * 5,
                            fontFamily: "CaveatBrush",
                            color: Colors.purple),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: GestureDetector(
                          onTap: () {
                            if (name != "Create My Own") {
                              List<String> purCar =
                                  settingsProv.purchasedCards as List<String>;
                              if (!purCar.contains(name)) {
                                purCar.add(name);
                                setState(() {
                                  settingsProv.setPurchasedCards(purCar);
                                });
                              }
                            }
                            debugPrint("purchased");
                            debugPrint(
                                "purCards: ${settingsProv.purchasedCards}");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EditList(name: textCards[index])));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border:
                                    Border.all(color: Colors.blue, width: 2),
                                color: Colors.yellow[50]),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        name,
                                        style: TextStyle(
                                            color: Colors.purple,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                SizeConfig.blockSizeVertical *
                                                    2.5),
                                      ),
                                      Text(
                                        !name.contains("Create")
                                            ? "\$0.99"
                                            : "\$1.99",
                                        style: TextStyle(
                                            color: Colors.purple,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                SizeConfig.blockSizeVertical *
                                                    2.5),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      !name.contains("Create")
                                          ? "Edit the items included in the $name card."
                                          : "Create a card with at least 25 items.",
                                      style: TextStyle(
                                          color: Colors.purple,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              SizeConfig.blockSizeVertical *
                                                  1.5),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.transparent, width: 1)),
                        padding: SizeConfig.screenWidth > 500
                            ? EdgeInsets.symmetric(
                                horizontal: SizeConfig.blockSizeHorizontal * 15,
                                vertical: SizeConfig.blockSizeVertical * 5)
                            : EdgeInsets.symmetric(
                                horizontal: SizeConfig.blockSizeHorizontal * 10,
                                vertical: SizeConfig.blockSizeVertical * 5),
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                          child: const Text("Restore Remove Ads Purchase"),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      )
                    ],
                  ),
                ),
              ));
        });
  }
}
