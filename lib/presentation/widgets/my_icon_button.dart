import 'package:flutter/material.dart';

class MyIconButton extends StatelessWidget {
  final IconData iconData;
  final Function() onPressed;
  const MyIconButton({Key? key, required this.iconData, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 10),
      iconSize: 30,
      icon: Icon(
        iconData,
      ),
    );
  }
}
