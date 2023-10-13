import 'package:flutter/material.dart';
import 'package:scavenger_hunt_bingo/utils/size_config.dart';

class DialogButton extends StatelessWidget {
  const DialogButton({
    Key? key,
    required this.onPressed,
    required this.title,
    required this.icon,
  }) : super(key: key);
  final VoidCallback onPressed;
  final String title;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          minimumSize: SizeConfig.screenWidth < 500
              ? Size(SizeConfig.blockSizeHorizontal * 25,
                  SizeConfig.blockSizeVertical * 4)
              : Size(SizeConfig.blockSizeHorizontal * 30,
                  SizeConfig.blockSizeVertical * 4),
          backgroundColor: Colors.yellow[50],
          foregroundColor: Colors.purple,
          elevation: 10,
          textStyle: TextStyle(
              fontSize: SizeConfig.screenWidth < 500
                  ? SizeConfig.blockSizeVertical * 3
                  : SizeConfig.blockSizeVertical * 3.5,
              fontFamily: "CaveatBrush")),
      onPressed: onPressed,
      icon: icon,
      label: Text(title),
    );
  }
}
