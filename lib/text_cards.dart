import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:scavenger_hunt_bingo/data/arrays.dart';
import 'package:scavenger_hunt_bingo/data/bingo_card.dart';
import 'package:scavenger_hunt_bingo/data/free_cards.dart';
import 'package:scavenger_hunt_bingo/providers/settings_provider.dart';
import 'package:scavenger_hunt_bingo/settings.dart';
import 'package:scavenger_hunt_bingo/widgets/paywall.dart';

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
  }

  final cardBox = Hive.box<BingoCard>('cards');
  // final List<String> textCards = [];
  // getTextCards() {
  //   for (var i = 0; i < cardBox.length; i++) {
  //     final bingoCard = cardBox.get(i) as BingoCard;

  //     if (bingoCard.canEdit) {
  //       textCards.add(bingoCard.name);
  //     }
  //   }
  //   debugPrint("textCards: $textCards");
  // }

  @override
  void initState() {
    // getTextCards();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var settingsProvider = Provider.of<SettingsProvider>(context, listen: true);
    debugPrint("settings created cards: ${settingsProvider.createdCards}");
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
            padding: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal * 3),
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
                Navigator.pushReplacement(
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
    );
  }

  _buildListView() {
    var settingsProv = Provider.of<SettingsProvider>(context, listen: true);

    List textCards =
        cardBox.values.where((element) => element.canEdit).toList();
    debugPrint("textCards length: ${textCards.length}");
    return Scrollbar(
      child: ListView.builder(
          shrinkWrap: true,
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
                    textCards[index].name,
                    style: TextStyle(
                        color: Colors.purple,
                        fontFamily: "CaveatBrush",
                        fontSize: SizeConfig.blockSizeVertical * 2.5),
                  ),
                  trailing: settingsProv.purchasedCards
                              .contains(textCards[index].name) ||
                          settingsProv.createdCards
                              .contains(textCards[index].name)
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
                    settingsProv.purchasedCards
                                .contains(textCards[index].name) ||
                            settingsProv.createdCards
                                .contains(textCards[index].name)
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EditList(name: textCards[index])))
                        : showPurchaseOptions(
                            context, textCards[index].name, index + 1);
                  }),
            );
            //         );
          }),
    );
  }

  setMyCardItems(String name) async {
    debugPrint("setItems called: save My Card to Hive");
    final cardBox = await Hive.openBox<BingoCard>('cards');
    List<String> cardItems = Resources.create;
    bool edit = true;
    final newCard = BingoCard(name, edit, cardItems);
    cardBox.add(newCard);
    debugPrint("cardBox length: ${cardBox.length}");
  }

  Future showPurchaseOptions(
      BuildContext context, String name, int index) async {
    var settingsProv = Provider.of<SettingsProvider>(context, listen: false);
    final offerings = await Purchases.getOfferings();

    if (offerings.current == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("No Options Found")));
    } else {
      final packages = offerings.current!.availablePackages;
      debugPrint(
          "text_cards-> showPurchaseOptions: name: $name, index: $index");
      if (!mounted) return;
      showModalBottomSheet(
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25))),
          context: context,
          builder: (context) {
            return PaywallWidget(
                title: "Purchase this Card",
                description: '',
                packages: packages,
                onClickedPackage: (package) async {
                  try {
                    CustomerInfo customerInfo =
                        await Purchases.purchasePackage(package);

                    final pkg = package.storeProduct.title
                        .replaceAll(RegExp('\\(.*?\\)'), '');
                    debugPrint("pkg: $pkg");
                    if (pkg.contains("Create")) {
                      debugPrint("create pkg");
                      if (!mounted) return;
                      List<String> createCar =
                          settingsProv.createdCards as List<String>;
                      int num = createCar.length + 1;
                      final cardName = 'My Card $num';

                      setState(() {
                        createCar.add(cardName);
                        settingsProv.setCreatedCards(createCar);
                        setMyCardItems(cardName);
                      });
                    } else if (customerInfo
                        .entitlements.all[rcEntitlements[index]]!.isActive) {
                      if (!mounted) return;

                      List<String> purCar =
                          settingsProv.purchasedCards as List<String>;
                      if (!purCar.contains(name)) {
                        purCar.add(name);
                        setState(() {
                          settingsProv.setPurchasedCards(purCar);
                        });
                        debugPrint("purCar: ${settingsProv.purchasedCards}");
                      }
                    }
                  } catch (e) {
                    debugPrint("Failed to purchase product. $e");
                  }
                  if (!mounted) return;
                  Navigator.pop(context);
                },
                index: index);
          });
    }
  }
}
