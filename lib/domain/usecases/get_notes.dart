import 'package:tasks_app/core/error/failure.dart';

import 'package:dartz/dartz.dart';

import '../../core/usecases/usecase.dart';
import '../contracts/note_contract.dart';
import '../entities/note.dart';

class GetNotes extends UseCase<List<Note>, NoParams> {
  final NoteContract contract;
  GetNotes(this.contract);

  @override
  Future<Either<Failure, List<Note>>> call(NoParams params) async {
    return await contract.getNotes();
  }
  
}