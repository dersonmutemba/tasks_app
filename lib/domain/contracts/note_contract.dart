import 'package:tasks_app/interfaces/dartz.dart';

import '../../core/error/failure.dart';
import '../../core/success/success.dart';
import '../entities/note.dart';

abstract class NoteContract {
  Future<Either<Failure, Success>> insertNote(Note note);
  Future<Either<Failure, Note>> getNote(String id);
  Future<Either<Failure, List<Note>>> getNotes();
  Future<Either<Failure, Success>> updateNote(Note note);
  Future<Either<Failure, Success>> deleteNote(String id);
  Future<Either<Failure, List<Note>>> searchNotes(String query);
}