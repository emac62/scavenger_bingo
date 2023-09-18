import 'package:flutter/material.dart';

Widget bingoBanner() {
  return Builder(builder: (context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.blue[100],
            border: Border(
              left: BorderSide(color: Colors.purple),
              top: BorderSide(color: Colors.purple),
              right: BorderSide(color: Colors.purple),
            )),
        child: Row(children: [
          Expanded(
            child: BannerLetter(
              size: size,
              letter: 'B',
            ),
          ),
          Expanded(child: BannerLetter(size: size, letter: "I")),
          Expanded(child: BannerLetter(size: size, letter: "N")),
          Expanded(child: BannerLetter(size: size, letter: "G")),
          Expanded(child: BannerLetter(size: size, letter: "O")),
        ]),
      ),
    );
  });
}

class BannerLetter extends StatelessWidget {
  const BannerLetter({
    Key? key,
    required this.size,
    required this.letter,
  }) : super(key: key);

  final Size size;
  final String letter;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            border: Border(
          left: BorderSide(color: Colors.purple, width: 0.5),
          top: BorderSide(color: Colors.purple, width: 0.5),
          right: BorderSide(color: Colors.purple, width: 0.5),
        )),
        child: Text(
          letter,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'CaveatBrush',
              fontSize: size.width * 0.08,
              color: Colors.blue),
        ));
  }
}
