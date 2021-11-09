import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:scavenger_hunt_bingo/settings.dart';
import 'package:scavenger_hunt_bingo/widgets/audio.dart';
import 'package:scavenger_hunt_bingo/widgets/size_config.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({
    Key? key,
  }) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    SizeConfig().init(context);
    return Scaffold(
      appBar: NewGradientAppBar(
        automaticallyImplyLeading: false,
        title: AutoSizeText(
          "Scavenger Bingo",
          style: TextStyle(
              color: Colors.yellow[50],
              fontFamily: 'CaveatBrush',
              fontSize: size.width,
              letterSpacing: 2.0),
        ),
        gradient: LinearGradient(colors: [Colors.purple, Colors.blue]),
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
                    applicationVersion: "1.1.2",
                    applicationLegalese: '©2021 borderlineBoomer',
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
        width: double.infinity,
        color: Colors.yellow[50],
        child: Padding(
          padding: EdgeInsets.only(top: size.height * 0.08),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                    child: Container(
                        height: size.width / 2,
                        width: size.width,
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
                    "A relaxing game to play with kids",
                    style: TextStyle(
                      color: Colors.purple,
                      fontFamily: 'CaveatBrush',
                      fontSize: size.width * 0.05,
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
                      fontSize: size.width * 0.05,
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
                      playSound('magicalSlice2.mp3');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingsPage()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text("Start"),
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
                            fontSize: size.width * 0.05,
                            fontFamily: 'CaveatBrush')),
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
