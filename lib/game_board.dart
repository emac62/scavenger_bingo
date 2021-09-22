import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:scavenger_hunt_bingo/main.dart';
import 'package:scavenger_hunt_bingo/widgets/bingoBoard.dart';
import 'package:scavenger_hunt_bingo/widgets/bingo_banner.dart';

class GameBoard extends StatefulWidget {
  final String selectedBoard;
  final String selectedPattern;
  const GameBoard(
      {Key? key, required this.selectedBoard, required this.selectedPattern})
      : super(key: key);

  @override
  _GameBoardState createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
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
          // Colors.green,
          Colors.blue
        ]),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Restart Game',
            onPressed: () {
              result.clear();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => IntroPage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.yellow[50],
        child: Center(
          child: Column(children: [
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 10, 8.0, 0),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "The card shows things found here ->",
                            style: TextStyle(
                                fontFamily: 'CaveatBrush',
                                fontSize: size.width * 0.05,
                                color: Colors.blue),
                          ),
                          Text(
                            widget.selectedBoard,
                            style: TextStyle(
                                fontFamily: 'CaveatBrush',
                                fontSize: size.width * 0.05,
                                color: Colors.purple),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Find this pattern ->",
                                style: TextStyle(
                                    fontFamily: 'CaveatBrush',
                                    fontSize: size.width * 0.05,
                                    color: Colors.blue),
                              ),
                              Text(
                                widget.selectedPattern,
                                style: TextStyle(
                                    fontFamily: 'CaveatBrush',
                                    fontSize: size.width * 0.05,
                                    color: Colors.purple),
                              )
                            ],
                          ),
                          Row(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            bingoBanner(),
            bingoBoard(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 10, 8, 25),
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text("Banner Ad goes here")),
              ),
            )
          ]),
        ),
      ),
    );
  }
}
