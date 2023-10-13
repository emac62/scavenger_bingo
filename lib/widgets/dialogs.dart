import 'package:flutter/material.dart';

import 'package:scavenger_hunt_bingo/utils/size_config.dart';

class ImageDialog extends StatefulWidget {
  final String selectedPattern;

  const ImageDialog({Key? key, required this.selectedPattern})
      : super(key: key);
  @override
  _ImageDialogState createState() => _ImageDialogState();
}

class _ImageDialogState extends State<ImageDialog> {
  var winningImage;

  getSelectedPatternImage(String selectedPattern) {
    switch (selectedPattern) {
      case "One Line":
        winningImage = 'assets/images/OneLinePort.png';
        break;
      case "Letter X":
        winningImage = 'assets/images/Cross.png';
        break;
      case "Full Card":
        winningImage = 'assets/images/Full.png';
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    getSelectedPatternImage(widget.selectedPattern);
    return Dialog(
      child: Container(
        width: SizeConfig.blockSizeHorizontal * 100,
        height: SizeConfig.blockSizeVertical * 60,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: ExactAssetImage(winningImage), fit: BoxFit.contain),
          color: Colors.yellow[50],
        ),
      ),
    );
  }
}
