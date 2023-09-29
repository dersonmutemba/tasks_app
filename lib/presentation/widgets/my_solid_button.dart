import 'package:flutter/material.dart';

class MySolidButton extends TextButton {
  final OutlinedBorder border = const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(25)),
  );
  @override
  ButtonStyle get style => TextButton.styleFrom(
        shape: border,
        backgroundColor: const Color.fromARGB(150, 225, 225, 225),
      );
  const MySolidButton({
    Key? key,
    required super.child,
    required super.onPressed,
  }) : super(key: key);
}
