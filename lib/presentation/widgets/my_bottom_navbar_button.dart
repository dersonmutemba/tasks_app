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
        side: BorderSide.none,
        foregroundColor: isEmphasized
            ? Colors.black
            : const Color.fromARGB(255, 126, 126, 126),
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
