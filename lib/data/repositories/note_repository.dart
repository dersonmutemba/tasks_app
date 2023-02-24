import 'package:dartz/dartz.dart';
import 'package:tasks_app/core/error/exception.dart';

import '../../core/error/failure.dart';
import '../../core/platform/network_info.dart';
import '../../domain/contracts/note_contract.dart';
import '../../domain/entities/note.dart';
import '../datasources/note_local_data_source.dart';
import '../datasources/note_remote_data_source.dart';

class NoteRepository implements NoteContract {
  final NoteRemoteDataSource remoteDataSource;
  final NoteLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NoteRepository(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, Note>> getNote(String id) {
    // TODO: implement getNote
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Note>>> getNotes() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteNotes = await remoteDataSource.getNotes();
        localDataSource.cacheNotes(remoteNotes);
        return Right(remoteNotes);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try{
        final localNotes = await localDataSource.getNotes();
        return Right(localNotes);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
