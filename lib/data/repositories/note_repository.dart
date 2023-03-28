import 'package:dartz/dartz.dart';
import 'package:tasks_app/core/error/exception.dart';
import 'package:tasks_app/core/success/success.dart';

import '../../core/error/failure.dart';
import '../../core/network/network_info.dart';
import '../../domain/contracts/note_contract.dart';
import '../../domain/entities/note.dart';
import '../datasources/note_local_data_source.dart';
import '../datasources/note_remote_data_source.dart';
import '../models/note_model.dart';

class NoteRepository implements NoteContract {
  final NoteRemoteDataSource remoteDataSource;
  final NoteLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NoteRepository(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, Note>> getNote(String id) async {
    try {
      final note = await localDataSource.getNote(id);
      return Right(note);
    } on CacheException {
      return Left(CacheFailure());
    }
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
      try {
        final localNotes = await localDataSource.getNotes();
        return Right(localNotes);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Success>> insertNote(Note note) async {
    if (await networkInfo.isConnected) {
      try {
        await localDataSource.insertNote(NoteModel.fromNote(note));
        await remoteDataSource.insertNote(note);
        return Right(RemoteInsertionSuccess());
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Right(InsertionSuccess(id: await localDataSource.insertNote(NoteModel.fromNote(note))));
    }
  }
}
