import 'package:dartz/dartz.dart';
import 'package:tasks_app/core/error/failure.dart';

import '../entities/note.dart';

abstract class NoteContract {
  Future<Either<Failure, Note>> getNote(String id);
  Future<Either<Failure, List<Note>>> getNotes();
}