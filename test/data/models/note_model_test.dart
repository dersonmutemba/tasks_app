import 'package:flutter_test/flutter_test.dart';
import 'package:tasks_app/domain/entities/note.dart';
import 'package:uuid/uuid.dart';

void main() {
  final testNoteModel = NoteModel(
      id: const Uuid(),
      title: "title",
      content: "content",
      createdAt: DateTime.now(),
      lastEdited: DateTime.now());

  test('Should be a subclass of Note entity', () async {
    expect(testNoteModel, isA<Note>());
  });
}
