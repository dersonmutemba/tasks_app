import 'package:flutter/material.dart';

class MyPopupMenuItem extends PopupMenuItem {
  final String title;
  final IconData? icon;
  final Color? color;
  final bool isImportant;
  final bool isEnabled;
  final Function() onClick;
  MyPopupMenuItem(
      {Key? key,
      required this.title,
      this.icon,
      this.color,
      this.isImportant = false,
      this.isEnabled = true,
      required this.onClick})
      : super(
          key: key,
          onTap: onClick,
          enabled: isEnabled,
          child: Row(
            children: [
              Icon(
                icon,
                color: color,
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                title,
                style: isImportant
                    ? TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                      )
                    : TextStyle(color: color),
              ),
            ],
          ),
        );
}
