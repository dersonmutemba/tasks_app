import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';

import '../../core/error/failure.dart';
import '../contracts/note_contract.dart';
import '../entities/note.dart';

class GetNote{
  final NoteContract contract;
  GetNote(this.contract);

  Future<Either<Failure, Note>> call({required Uuid id}) => contract.getNote(id);
}