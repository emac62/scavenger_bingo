import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

List<int> selectedTiles = [];

addToSelectedTiles(int) {
  selectedTiles.add(int);
}

removeFromSelectedTiles(int) {
  selectedTiles.removeWhere((element) => element == int);
}

// ignore: must_be_immutable
class ListTileWidget extends StatefulWidget {
  final String name;
  final int index;
  bool isSelected;

  ListTileWidget(
      {required Key key,
      required this.name,
      required this.index,
      required this.isSelected})
      : super(key: key);

  @override
  ListTileWidgetState createState() => ListTileWidgetState();
}

class ListTileWidgetState extends State<ListTileWidget> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return GestureDetector(
        onTap: () {
          setState(() {
            if (widget.isSelected) {
              widget.isSelected = !widget.isSelected;
              removeFromSelectedTiles(widget.index);
            } else {
              widget.isSelected = !widget.isSelected;
              addToSelectedTiles(widget.index);
            }
          });
        },
        child: Container(
          decoration: BoxDecoration(border: Border.all()),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.isSelected ? Colors.yellow : null,
                ),
                child: Center(
                  child: ListTile(
                      contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
                      dense: true,
                      title: AutoSizeText(
                        widget.index == 12 ? "FREE" : widget.name.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: (widget.index != 12)
                            ? TextStyle(
                                fontFamily: 'CaveatBrush',
                                fontSize: size.width * 0.03)
                            : TextStyle(
                                fontFamily: 'CaveatBrush',
                                fontSize: size.width * 0.05,
                                color: Colors.purple),
                      )),
                )),
          ),
        ));
  }
}
