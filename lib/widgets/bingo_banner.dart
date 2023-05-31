import 'package:flutter/material.dart';

Widget bingoBanner() {
  return Builder(builder: (context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Container(
        color: Colors.blue[100],
        child: Row(children: [
          Expanded(
            child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.purple)),
                child: Text(
                  "B",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'CaveatBrush',
                      fontSize: size.width * 0.08,
                      color: Colors.blue),
                )),
          ),
          Expanded(
            child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.purple)),
                child: Text(
                  "I",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'CaveatBrush',
                      fontSize: size.width * 0.08,
                      color: Colors.blue),
                )),
          ),
          Expanded(
            child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.purple)),
                child: Text(
                  "N",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'CaveatBrush',
                      fontSize: size.width * 0.08,
                      color: Colors.blue),
                )),
          ),
          Expanded(
            child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.purple)),
                child: Text(
                  "G",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'CaveatBrush',
                      fontSize: size.width * 0.08,
                      color: Colors.blue),
                )),
          ),
          Expanded(
            child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.purple)),
                child: Text(
                  "O",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'CaveatBrush',
                      fontSize: size.width * 0.08,
                      color: Colors.blue),
                )),
          ),
        ]),
      ),
    );
  });
}
