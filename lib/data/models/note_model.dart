import '../../domain/entities/note.dart';

class NoteModel extends Note {
  NoteModel(
      {required String id,
      required String title,
      required String content,
      required DateTime createdAt,
      required DateTime lastEdited})
      : super(
            id: id,
            title: title,
            content: content,
            createdAt: createdAt,
            lastEdited: lastEdited);
}
