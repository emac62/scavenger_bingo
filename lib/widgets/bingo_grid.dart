import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:scavenger_hunt_bingo/providers/settings_provider.dart';

import 'package:scavenger_hunt_bingo/utils/size_config.dart';
import 'package:screenshot/screenshot.dart';
import '../data/set_random_list.dart';
import 'list_tile_widget.dart';

class BingoGrid extends StatefulWidget {
  const BingoGrid({
    Key? key,
    required this.selectedBoard,
    required this.screenshotController,
  }) : super(key: key);
  final String selectedBoard;
  final ScreenshotController screenshotController;

  @override
  State<BingoGrid> createState() => _BingoGridState();
}

class _BingoGridState extends State<BingoGrid> {
  List _selectedList = [];

  var _buttonName = [];
  List<BingoItem> _itemList = [];

  void setList() {
    _selectedList =
        Provider.of<SettingsProvider>(context, listen: false).currentGame;

    if (!widget.selectedBoard.contains("Images")) {
      _selectedList.forEach((item) {
        _buttonName.add(item.toString());
      });

      for (var i = 0; i < _buttonName.length; i++) {
        _itemList.add(BingoItem(
            name: _buttonName[i],
            icon: IconData(i),
            index: i,
            screenshotController: widget.screenshotController));
      }
    } else {
      for (var i = 0; i < _selectedList.length; i++) {
        _itemList.add(BingoItem(
            name: _selectedList[i],
            index: i,
            icon: getIconImage(_selectedList[i]),
            screenshotController: widget.screenshotController));
      }
    }
  }

  @override
  void initState() {
    setList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: SizeConfig.isPhone ? 0.9 / 1 : 2.5 / 2),
        itemCount: _selectedList.length,
        itemBuilder: (context, index) {
          return ListTileWidget(
              name: _itemList[index].name!,
              index: index,
              icon: _itemList[index].icon!,
              screenshotController: _itemList[index].screenshotController!);
        },
      ),
    );
  }

  // List listTileWidgets(
  //   BuildContext context,
  //   String selectedBoard,
  //   ScreenshotController screenshotController,
  // ) {
  //   List<Widget> _itemList = [];
  //   var _buttonName = [];
  //   _selectedList =
  //       Provider.of<SettingsProvider>(context, listen: false).currentGame;

  //   if (!selectedBoard.contains("Images")) {
  //     _selectedList.forEach((item) {
  //       _buttonName.add(item.toString());
  //     });

  //     for (var i = 0; i < _buttonName.length; i++) {
  //       _itemList.add(ListTileWidget(
  //           name: _buttonName[i],
  //           icon: IconData(i),
  //           index: i,
  //           screenshotController: screenshotController));
  //     }
  //     return _itemList;
  //   } else {
  //     for (var i = 0; i < _selectedList.length; i++) {
  //       _itemList.add(ListTileWidget(
  //           name: _selectedList[i],
  //           index: i,
  //           icon: getIconImage(_selectedList[i]),
  //           screenshotController: screenshotController));
  //     }

  //     return _itemList;
  //   }
  // }
}

class BingoItem {
  String? name;
  IconData? icon;
  int? index;
  ScreenshotController? screenshotController;

  BingoItem({this.icon, this.index, this.name, this.screenshotController});
}
