import 'package:flutter/material.dart';
import 'package:scavenger_hunt_bingo/utils/size_config.dart';

class PurpleBtn extends StatelessWidget {
  const PurpleBtn({
    Key? key,
    required this.name,
    required this.font,
    required this.onPressed,
    required this.fontSize,
  }) : super(key: key);
  final String name;
  final String font;
  final VoidCallback onPressed;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SizedBox(
      width: SizeConfig.blockSizeHorizontal * 45,
      child: ElevatedButton(
          onPressed: onPressed,
          child: Padding(
            padding: SizeConfig.isPhone
                ? EdgeInsets.symmetric(
                    vertical: SizeConfig.blockSizeVertical * 1)
                : EdgeInsets.symmetric(
                    vertical: SizeConfig.blockSizeVertical * 1),
            child: Text(name),
          ),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.yellow[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Colors.purple,
            side: BorderSide(
              color: Colors.blue,
              width: 2.0,
            ),
            elevation: 10,
            textStyle: TextStyle(
                fontFamily: font,
                fontWeight:
                    name == "Play Bingo" ? FontWeight.normal : FontWeight.bold,
                fontSize: fontSize),
          )),
    );
  }
}
