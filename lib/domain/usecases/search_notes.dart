import 'package:dartz/dartz.dart';

import '../../core/error/failure.dart';
import '../../core/usecases/usecase.dart';
import '../contracts/note_contract.dart';
import '../entities/note.dart';

class SearchNotes extends UseCase<List<Note>, Params> {
  final NoteContract contract;
  SearchNotes(this.contract);

  @override
  Future<Either<Failure, List<Note>>> call(Params params) async {
    return await contract.searchNotes(params.query);
  }
}

class Params {
  final String query;
  Params({required this.query});

  @override
  bool operator ==(Object other) =>
      other is Params &&
      other.runtimeType == runtimeType &&
      other.query == query;

  @override
  int get hashCode => query.hashCode;
}
