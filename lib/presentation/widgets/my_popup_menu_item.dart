import 'package:flutter/material.dart';

class MyPopupMenuItem extends PopupMenuItem {
  final String title;
  final IconData? icon;
  final Color? color;
  final bool isImportant;
  MyPopupMenuItem(
      {Key? key,
      required this.title,
      this.icon,
      this.color,
      this.isImportant = false})
      : super(
          key: key,
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
        // TODO: Add a required onTap method
}
