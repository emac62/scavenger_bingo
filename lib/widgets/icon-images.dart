import 'package:flutter/material.dart';

class IconImages extends StatefulWidget {
  final String name;
  final IconData icon;
  const IconImages({Key? key, required this.name, required this.icon})
      : super(key: key);

  @override
  _IconImagesState createState() => _IconImagesState();
}

class _IconImagesState extends State<IconImages> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Icon(
            widget.icon,
            color: Colors.purple,
          ),
          Text(
            widget.name,
            style: TextStyle(color: Colors.purple),
          )
        ],
      ),
    );
  }
}
