import 'package:dartz/dartz.dart';

import '../../core/error/failure.dart';
import '../../domain/contracts/note_contract.dart';
import '../../domain/entities/note.dart';

class NoteRepository implements NoteContract {
  @override
  Future<Either<Failure, Note>> getNote(String id) {
    // TODO: implement getNote
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Note>>> getNotes() {
    // TODO: implement getNotes
    throw UnimplementedError();
  }

}