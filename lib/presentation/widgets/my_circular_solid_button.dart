import 'package:flutter/widgets.dart';

import 'my_solid_button.dart';

class MyCircularSolidButton extends MySolidButton {
  @override
  OutlinedBorder get border => const CircleBorder();
  const MyCircularSolidButton({
    Key? key,
    required super.child,
    required super.onPressed,
  }) : super(key: key);
}
