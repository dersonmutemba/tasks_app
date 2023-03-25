import 'package:dartz/dartz.dart';
import 'package:tasks_app/core/error/failure.dart';

import '../../core/success/success.dart';
import '../entities/note.dart';

abstract class NoteContract {
  Future<Either<Failure, Success>> insertNote(Note note);
  Future<Either<Failure, Note>> getNote(String id);
  Future<Either<Failure, List<Note>>> getNotes();
}