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

  factory NoteModel.fromJson(Map<String, dynamic> json) => NoteModel(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        createdAt: DateTime.parse(json["createdAt"]),
        lastEdited: DateTime.parse(
          json["lastEdited"],
        ),
      );

  factory NoteModel.fromNote(Note note) => NoteModel(
        id: note.id,
        title: note.title,
        content: note.content,
        createdAt: note.createdAt,
        lastEdited: note.lastEdited,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "content": content,
        "createdAt": createdAt.toIso8601String(),
        "lastEdited": lastEdited.toIso8601String()
      };
}
