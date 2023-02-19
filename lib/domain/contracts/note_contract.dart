import 'package:dartz/dartz.dart';
import 'package:tasks_app/core/error/failure.dart';
import 'package:uuid/uuid.dart';

import '../entities/note.dart';

abstract class NoteContract {
  Future<Either<Failure, Note>> getNote(Uuid id);
  Future<Either<Failure, List<Note>>> getNotes();
}