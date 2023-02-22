import '../../domain/entities/note.dart';

abstract class NoteLocalDataSource {
  Future<Note> getNote(String id);

  Future<List<Note>> getNotes();
}
