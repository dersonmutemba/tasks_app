import 'package:flutter/material.dart';

class MySolidButton extends StatelessWidget {
  final Widget child;
  final Function() onPressed;
  final OutlinedBorder border = const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(25)),
  );
  const MySolidButton({
    Key? key,
    required this.child,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        shape: border,
        backgroundColor: const Color.fromARGB(150, 225, 225, 225),
        foregroundColor: Theme.of(context).textTheme.bodyMedium!.color,
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
