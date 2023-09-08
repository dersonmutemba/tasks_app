import 'package:flutter/material.dart';

import '../../../domain/entities/note.dart';

class NoteView extends StatelessWidget {
  final Note note;
  final Function openNote;
  const NoteView({Key? key, required this.note, required this.openNote})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      title: Text(
        note.title,
        maxLines: 1,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      subtitle: Container(
        padding: const EdgeInsets.only(top: 8, bottom: 4),
        child: Text(
          note.content,
          maxLines: 3,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
        ),
      ),
      enableFeedback: true,
      onTap: () async {
        await openNote();
      },
    );
  }
}
