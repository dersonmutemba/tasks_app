import 'package:flutter/material.dart';

import '../../../domain/entities/note.dart';
import '../../pages/note_page/note_page.dart';

class NoteView extends StatelessWidget {
  final Note note;
  const NoteView({Key? key, required this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(note.title),
      subtitle: Text(note.content),
      enableFeedback: true,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => NotePage(context, note: note),
        ),
      ),
    );
  }
}
