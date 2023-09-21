import 'package:flutter/material.dart';

class MySearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(dynamic) onChanged;
  const MySearchBar({Key? key, required this.controller, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, bottom: 10, right: 20),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide.none,
          ),
          hintText: 'Search...',
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          fillColor: Color.fromRGBO(25, 25, 25, .1),
          filled: true,
        ),
        maxLines: 1,
        onChanged: (value) {
          onChanged(value);
        },
      ),
    );
  }
}