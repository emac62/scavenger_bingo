import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import '../data/set_random_list.dart';
import 'list_tile_widget.dart';

class BingoGrid extends StatefulWidget {
  const BingoGrid(
      {Key? key,
      required this.selectedBoard,
      required this.screenshotController})
      : super(key: key);
  final String selectedBoard;
  final ScreenshotController screenshotController;

  @override
  State<BingoGrid> createState() => _BingoGridState();
}

class _BingoGridState extends State<BingoGrid> {
  List selectedList = [];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Container(
        color: Colors.yellow[50],
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 5,
          childAspectRatio: (size.width / size.height) * 1.8,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
          children: listTileWidgets(
              context, widget.selectedBoard, widget.screenshotController),
        ),
      ),
    );
  }

  List<Widget> listTileWidgets(
    BuildContext context,
    String selectedBoard,
    ScreenshotController screenshotController,
  ) {
    selectedList = setRandomList(context, widget.selectedBoard);
    List<Widget> _itemList = [];
    var _buttonName = [];

    if (!selectedBoard.contains("Images")) {
      selectedList.forEach((item) {
        _buttonName.add(item.toString());
      });

      for (var i = 0; i < _buttonName.length; i++) {
        _itemList.add(ListTileWidget(
          name: _buttonName[i],
          icon: IconData(i),
          index: i,
          screenshotController: screenshotController,
        ));
      }
      return _itemList;
    } else {
      for (var i = 0; i < selectedList.length; i++) {
        _itemList.add(ListTileWidget(
          name: selectedList[i],
          index: i,
          icon: getIconImage(selectedList[i]),
          screenshotController: screenshotController,
        ));
      }

      return _itemList;
    }
  }
}
