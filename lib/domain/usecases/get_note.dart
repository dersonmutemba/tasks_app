import 'package:tasks_app/interfaces/dartz.dart';

import '../../core/error/failure.dart';
import '../../core/usecases/usecase.dart';
import '../contracts/note_contract.dart';
import '../entities/note.dart';

class GetNote extends UseCase<Note, Params> {
  final NoteContract contract;
  GetNote(this.contract);

  @override
  Future<Either<Failure, Note>> call(Params params) async =>
      contract.getNote(params.id);
}

class Params {
  final String id;
  Params({required this.id});

  @override
  bool operator ==(Object other) =>
      other is Params && other.runtimeType == runtimeType && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
