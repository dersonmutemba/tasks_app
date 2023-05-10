import 'package:flutter/material.dart';

class MyBottomNavBarButton extends StatelessWidget {
  final bool isEmphasized;
  final IconData icon;
  final String text;
  final void Function()? onPressed;
  const MyBottomNavBarButton(
      {Key? key,
      this.isEmphasized = false,
      required this.icon,
      required this.text,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: isEmphasized
            ? Theme.of(context).primaryColor
            : Theme.of(context).textTheme.bodyMedium!.color,
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          Text(text),
        ],
      ),
    );
  }
}
