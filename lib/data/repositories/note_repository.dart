import 'package:dartz/dartz.dart';

import '../../core/error/exception.dart';
import '../../core/error/failure.dart';
import '../../core/network/network_info.dart';
import '../../core/success/success.dart';
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
        localNotes.sort((a, b) => b.lastEdited.compareTo(a.lastEdited));
        return Right(localNotes);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Success>> insertNote(Note note) async {
    try {
      _handleEmptyNotes(note);
      if (await networkInfo.isConnected) {
        await localDataSource.insertNote(NoteModel.fromNote(note));
        await remoteDataSource.insertNote(note);
        return Right(RemoteInsertionSuccess(id: note.id));
      } else {
        return Right(InsertionSuccess(
            id: await localDataSource.insertNote(NoteModel.fromNote(note))));
      }
    } on ServerException {
      return Left(ServerFailure());
    } on EmptyNoteException {
      return Left(EmptyNoteFailure());
    }
  }

  @override
  Future<Either<Failure, Success>> updateNote(Note note) async {
    try {
      _handleEmptyNotes(note);
      if (await networkInfo.isConnected) {
        await localDataSource.updateNote(NoteModel.fromNote(note));
        await remoteDataSource.updateNote(note);
        return Right(RemoteUpdateSuccess());
      } else {
        await localDataSource.updateNote(NoteModel.fromNote(note));
        return Right(UpdateSuccess());
      }
    } on ServerException {
      return Left(ServerFailure());
    } on EmptyNoteException {
      return Left(EmptyNoteFailure());
    }
  }

  @override
  Future<Either<Failure, Success>> deleteNote(String id) async {
    try {
      if (await networkInfo.isConnected) {
        await localDataSource.deleteNote(id);
        await remoteDataSource.deleteNote(id);
        return Right(RemoteDeleteSuccess());
      } else {
        await localDataSource.deleteNote(id);
        return Right(DeleteSuccess());
      }
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Note>>> searchNotes(String query) async {
    try {
      final notes = await localDataSource.searchNotes(query);
      return Right(notes);
    } on CacheException {
      return Left(CacheFailure());
    } on Exception {
      return Left(UnknownFailure());
    }
  }

  void _handleEmptyNotes(Note note) {
    if (note.title.trim() == '' && note.content.trim() == '') {
      throw EmptyNoteException();
    }
  }
}
