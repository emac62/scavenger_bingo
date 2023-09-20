import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:scavenger_hunt_bingo/data/set_random_list.dart';
import 'package:scavenger_hunt_bingo/providers/settings_provider.dart';
import 'package:scavenger_hunt_bingo/settings.dart';
import 'package:scavenger_hunt_bingo/widgets/audio.dart';
import 'package:scavenger_hunt_bingo/utils/size_config.dart';

import 'data/arrays.dart';
import 'data/bingo_card.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({
    Key? key,
  }) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  List<String> allCards = [
    "Create My Own",
    "Backyard",
    "Bedroom",
    "Car Ride",
    "Christmas",
    "City Walk",
    "Family Room",
    "Halloween",
    "Stay Indoors",
    "Trail Walk",
    "Virtual Meeting",
    "Waiting Room",
    "City with Images",
    "Classroom with Images",
    "Grocery Store with Images",
    "Indoors with Images",
    "Restaurant with Images",
    "Trail with Images",
  ];
  getResourceLists(String name) {
    List<String> list = [];
    switch (name) {
      case "Create My Own":
        list = Resources.create;
        break;
      case "City Walk":
        list = Resources.city;
        break;
      case "Trail Walk":
        list = Resources.trail;
        break;
      case "Stay Indoors":
        list = Resources.indoors;
        break;
      case "Backyard":
        list = Resources.backyard;
        break;
      case "Car Ride":
        list = Resources.carRide;
        break;
      case "Waiting Room":
        list = Resources.waitingRoom;
        break;
      case "Virtual Meeting":
        list = Resources.virtual;
        break;
      case "Family Room":
        list = Resources.familyRoom;
        break;
      case "Bedroom":
        list = Resources.bedroom;
        break;
      case "Halloween":
        list = Resources.halloween;
        break;
      case "Christmas":
        list = Resources.christmas;
        break;
      case "City with Images":
        list = Resources.cityIcons;
        break;
      case "Trail with Images":
        list = Resources.trailIcons;
        break;
      case "Indoors with Images":
        list = Resources.indoorIcons;
        break;
      case "Grocery Store with Images":
        list = Resources.grocery;
        break;
      case "Classroom with Images":
        list = Resources.classroom;
        break;
      case "Restaurant with Images":
        list = Resources.restaurant;
        break;
    }
    return list;
  }

  Box cardBox = Hive.box<BingoCard>('cards');

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      initialization();
    });
  }

  void initialization() async {
    FlutterNativeSplash.remove();
    var settings = Provider.of<SettingsProvider>(context, listen: false);
    bool setHive = settings.hiveActivated;
    if (!setHive) {
      // set up Hive
      addArraysToHive();
      settings.setHive(true);
    }
  }

  void addArraysToHive() async {
    final cardBox = await Hive.openBox<BingoCard>("cards");
    List<String> oldList = [];
    bool edit = true;

    for (var i = 0; i < allCards.length; i++) {
      oldList = getResourceLists(allCards[i]);
      edit = !allCards[i].contains("Images");
      final newCard = BingoCard(allCards[i], edit, oldList);

      cardBox.add(newCard);
    }
    debugPrint("cardsAdded");
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var settingsProvider = Provider.of<SettingsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Scavenger Bingo",
          style: TextStyle(
              color: Colors.yellow[50],
              fontFamily: 'CaveatBrush',
              fontSize: SizeConfig.blockSizeVertical * 5,
              letterSpacing: 2.0),
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
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
                child: Icon(Icons.info),
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationIcon: Image.asset(
                      'assets/images/IntroImage.png',
                      height: 60,
                      width: 60,
                    ),
                    applicationName: "Scavenger Hunt Bingo",
                    applicationVersion: "2.0.2",
                    applicationLegalese: '©2023 borderlineBoomer',
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: 15),
                          child: Column(
                            children: [
                              Text(
                                'A bingo like game that can be played pretty much anywhere!',
                                style: TextStyle(color: Colors.blue),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Please do not play this game while driving or operating machinery.',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ],
                          ))
                    ],
                  );
                }),
          )
        ],
      ),
      body: Container(
        width: SizeConfig.blockSizeHorizontal * 100,
        height: SizeConfig.blockSizeVertical * 100,
        color: Colors.yellow[50],
        child: Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                    child: Container(
                        height: SizeConfig.blockSizeVertical * 40,
                        width: SizeConfig.blockSizeHorizontal * 100,
                        child: Image.asset(
                          "assets/images/IntroImage.png",
                          fit: BoxFit.contain,
                        ))),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                  child: Text(
                    "A relaxing game to play",
                    style: TextStyle(
                      color: Colors.purple,
                      fontFamily: 'CaveatBrush',
                      fontSize: SizeConfig.blockSizeHorizontal * 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                  child: Text(
                    "with kids",
                    style: TextStyle(
                      color: Colors.purple,
                      fontFamily: 'CaveatBrush',
                      fontSize: SizeConfig.blockSizeHorizontal * 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                  child: Text(
                    "or on your own",
                    style: TextStyle(
                      color: Colors.purple,
                      fontFamily: 'CaveatBrush',
                      fontSize: SizeConfig.blockSizeHorizontal * 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 10),
                  child: ElevatedButton(
                    onPressed: () {
                      if (settingsProvider.withSound)
                        playSound('magicalSlice.mov');

                      setRandomList(context, settingsProvider.selectedBoard);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SettingsPage()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text("Start"),
                    ),
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.yellow[50],
                        backgroundColor: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        side: BorderSide(
                          color: Colors.blue,
                          width: 3.0,
                        ),
                        elevation: 20,
                        textStyle: TextStyle(
                            fontSize: SizeConfig.blockSizeHorizontal * 10,
                            fontFamily: 'CaveatBrush')),
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
