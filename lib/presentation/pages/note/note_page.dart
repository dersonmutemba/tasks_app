import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../widgets/my_icon_button.dart';

class NotePage extends StatelessWidget {
  const NotePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                MyIconButton(
                  iconData: Icons.arrow_back_ios,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const Spacer(),
                MyIconButton(
                  iconData: Icons.more_vert,
                  onPressed: () {
                    // TODO: Add a popup menu and some options
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            const Expanded(child: TextField())
          ],
        ),
      ),
    );
  }
}
