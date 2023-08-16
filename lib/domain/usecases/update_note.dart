import 'package:tasks_app/interfaces/dartz.dart';

import '../../core/error/failure.dart';
import '../../core/success/success.dart';
import '../../core/usecases/usecase.dart';
import '../contracts/note_contract.dart';
import '../entities/note.dart';

class UpdateNote extends UseCase<Success, Params> {
  final NoteContract contract;
  UpdateNote(this.contract);

  @override
  Future<Either<Failure, Success>> call(Params params) async => contract.updateNote(params.note);
}

class Params {
  final Note note;
  Params({required this.note});

  @override
  bool operator ==(Object other) =>
      other is Params && other.runtimeType == runtimeType && other.note == note;

  @override
  int get hashCode => note.hashCode;
}
