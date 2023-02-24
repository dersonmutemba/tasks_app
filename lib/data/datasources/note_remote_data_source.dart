import '../../domain/entities/note.dart';

abstract class NoteRemoteDataSource {
  Future<List<Note>> getNotes();
}
