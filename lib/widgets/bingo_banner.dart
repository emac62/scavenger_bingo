import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

Widget bingoBanner() {
  return Builder(builder: (context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Container(
        color: Colors.blue[100],
        child: Row(children: [
          Expanded(
            child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.purple)),
                child: AutoSizeText(
                  "B",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'CaveatBrush',
                      fontSize: size.width * 0.1,
                      color: Colors.blue),
                )),
          ),
          Expanded(
            child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.purple)),
                child: AutoSizeText(
                  "I",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'CaveatBrush',
                      fontSize: size.width * 0.1,
                      color: Colors.blue),
                )),
          ),
          Expanded(
            child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.purple)),
                child: AutoSizeText(
                  "N",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'CaveatBrush',
                      fontSize: size.width * 0.1,
                      color: Colors.blue),
                )),
          ),
          Expanded(
            child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.purple)),
                child: AutoSizeText(
                  "G",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'CaveatBrush',
                      fontSize: size.width * 0.1,
                      color: Colors.blue),
                )),
          ),
          Expanded(
            child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.purple)),
                child: AutoSizeText(
                  "O",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'CaveatBrush',
                      fontSize: size.width * 0.1,
                      color: Colors.blue),
                )),
          ),
        ]),
      ),
    );
  });
}
