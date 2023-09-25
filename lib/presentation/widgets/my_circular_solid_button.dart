import 'package:flutter/widgets.dart';

import 'my_solid_button.dart';

class MyCircularSolidButton extends MySolidButton {
  @override
  final OutlinedBorder border = const CircleBorder();
  const MyCircularSolidButton({
    Key? key,
    required super.child,
    required super.onPressed,
  }) : super(key: key);
}
