import 'package:dartz/dartz.dart';

import '../../core/error/failure.dart';
import '../../core/success/success.dart';
import '../../core/usecases/usecase.dart';
import '../contracts/note_contract.dart';

class DeleteNote extends UseCase<Success, Params> {
  final NoteContract contract;
  DeleteNote(this.contract);

  @override
  Future<Either<Failure, Success>> call(Params params) async => contract.deleteNote(params.id);
}

class Params {
  final String id;
  Params({required this.id});

  @override
  bool operator == (Object other) =>
  other is Params && other.runtimeType == runtimeType && other.id == id;

  @override
  int get hashCode => id.hashCode;
}