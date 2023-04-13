import 'package:flutter/material.dart';

import '../../../domain/entities/note.dart';

class NoteView extends StatelessWidget {
  final Note note;
  final Function openNote;
  const NoteView({Key? key, required this.note, required this.openNote}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(note.title),
      subtitle: Text(note.content),
      enableFeedback: true,
      onTap: () async {
        await openNote();
      },
    );
  }
}
