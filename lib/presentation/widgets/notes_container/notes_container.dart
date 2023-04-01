import 'package:flutter/widgets.dart';

import 'note_list/note_list.dart';

class NotesContainer extends StatelessWidget {
  const NotesContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: const [Expanded(child: NoteList())],
      ),
    );
  }
}
