import 'package:flutter/material.dart';

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
            TextField(
              maxLines: 1,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Title...',
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Expanded(
              child: TextField(
                expands: true,
                minLines: null,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Write anything...',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
