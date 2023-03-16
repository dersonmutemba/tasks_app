import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../widgets/my_icon.dart';

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
                const MyIcon(iconData: Icons.cancel_outlined),
                const Spacer(),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    
                  ),
                  child: const MyIcon(iconData: Icons.check),
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
