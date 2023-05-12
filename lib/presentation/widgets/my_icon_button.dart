import 'package:flutter/material.dart';

class MyIconButton extends StatelessWidget {
  final IconData iconData;
  final Function() onPressed;
  final String? tooltip;
  const MyIconButton(
      {Key? key, required this.iconData, required this.onPressed, this.tooltip})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 10),
      tooltip: tooltip,
      icon: Icon(
        iconData,
      ),
    );
  }
}
