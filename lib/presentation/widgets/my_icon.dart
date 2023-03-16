import 'package:flutter/material.dart';

class MyIcon extends StatelessWidget {
  final IconData iconData;
  const MyIcon({Key? key, required this.iconData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      iconData,
      size: 50,
    );
  }
}
