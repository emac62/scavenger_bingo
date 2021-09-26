import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:scavenger_hunt_bingo/ad_state.dart';
import 'package:scavenger_hunt_bingo/game_board.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final initFuture = MobileAds.instance.initialize();
  final adState = AdState(initFuture);
  final RequestConfiguration requestConfiguration = RequestConfiguration(
      tagForChildDirectedTreatment: TagForChildDirectedTreatment.yes);
  MobileAds.instance.updateRequestConfiguration(requestConfiguration);

  runApp(Provider.value(
      value: adState, builder: (context, child) => ScavengerBingo()));
}

class ScavengerBingo extends StatefulWidget {
  const ScavengerBingo({Key? key}) : super(key: key);

  @override
  _ScavengerBingoState createState() => _ScavengerBingoState();
}

class _ScavengerBingoState extends State<ScavengerBingo> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IntroPage(),
    );
  }
}

class IntroPage extends StatefulWidget {
  const IntroPage({
    Key? key,
  }) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

String selectedBoard = 'City';
String selectedPattern = 'One Line';

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

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
        gradient: LinearGradient(colors: [
          // Colors.red,
          // Colors.orange,
          Colors.purple,
          //Colors.green,
          Colors.blue
        ]),
      ),
      body: Container(
        width: double.infinity,
        color: Colors.yellow[50],
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                  child: Container(
                      child: Image.asset("assets/images/IntroImage.png"))),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  "Choose your game board:",
                  style: TextStyle(
                      fontSize: 36,
                      color: Colors.purple,
                      fontFamily: 'CaveatBrush'),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.blue, width: 4)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    dropdownColor: Colors.purple,
                    iconEnabledColor: Colors.yellow.shade50,
                    elevation: 10,
                    value: selectedBoard,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedBoard = newValue!;
                      });
                    },
                    items: <String>['City', 'Trail', 'Indoors']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                              fontSize: 28,
                              color: Colors.yellow[50],
                              fontFamily: 'CaveatBrush'),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  "Select a winning pattern:",
                  style: TextStyle(
                      fontSize: 36,
                      color: Colors.blue,
                      fontFamily: 'CaveatBrush'),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.purple, width: 4)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    dropdownColor: Colors.blue,
                    iconEnabledColor: Colors.yellow.shade50,
                    elevation: 10,
                    value: selectedPattern,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedPattern = newValue!;
                      });
                    },
                    items: <String>['One Line', 'Cross', 'Full Card']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(
                              fontSize: 28,
                              color: Colors.yellow[50],
                              fontFamily: 'CaveatBrush'),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 10),
                child: ElevatedButton(
                  onPressed: () {
                    print("play tapped");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GameBoard(
                              selectedBoard: selectedBoard,
                              selectedPattern: selectedPattern)),
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
                          TextStyle(fontSize: 36, fontFamily: 'CaveatBrush')),
                ),
              )
            ]),
      ),
    );
  }
}
