import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tasks_app/core/error/exception.dart';
import 'package:tasks_app/core/error/failure.dart';
import 'package:tasks_app/core/network/network_info.dart';
import 'package:tasks_app/data/datasources/note_local_data_source.dart';
import 'package:tasks_app/data/datasources/note_remote_data_source.dart';
import 'package:tasks_app/data/models/note_model.dart';
import 'package:tasks_app/data/repositories/note_repository.dart';
import 'package:tasks_app/domain/entities/note.dart';

import 'note_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<NetworkInfo>()])
@GenerateNiceMocks([MockSpec<NoteLocalDataSource>()])
@GenerateNiceMocks([MockSpec<NoteRemoteDataSource>()])
void main() {
  late NoteRepository repository;
  late MockNoteRemoteDataSource mockNoteRemoteDataSource;
  late MockNoteLocalDataSource mockNoteLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockNoteRemoteDataSource = MockNoteRemoteDataSource();
    mockNoteLocalDataSource = MockNoteLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NoteRepository(
        remoteDataSource: mockNoteRemoteDataSource,
        localDataSource: mockNoteLocalDataSource,
        networkInfo: mockNetworkInfo);
  });

  const String testId = "110ec58a-a0f2-4ac4-8393-c866d813b8d1";
  final testNoteModel = NoteModel(
      id: "110ec58a-a0f2-4ac4-8393-c866d813b8d1",
      title: "title",
      content: "content",
      createdAt: DateTime.parse("2023-02-22T19:29:39.242"),
      lastEdited: DateTime.parse("2023-02-22T19:29:39.242"));
  final testNoteModelList = [testNoteModel];
  final Note testNote = testNoteModel;

  test('Should check if device is offline', () {
    when(mockNetworkInfo.isConnected)
        .thenAnswer((realInvocation) async => true);

    repository.getNotes();

    verify(mockNetworkInfo.isConnected);
  });

  group('If device is online', () {
    setUp(() => when(mockNetworkInfo.isConnected)
        .thenAnswer((realInvocation) async => true));

    test('Should return remote data', () async {
      when(mockNoteRemoteDataSource.getNotes())
          .thenAnswer((realInvocation) async => testNoteModelList);

      final actual = await repository.getNotes();

      verify(mockNoteRemoteDataSource.getNotes());
      expect(actual, equals(Right(testNoteModelList)));
    });

    test('Should save data offline if successfully get data from remote source',
        () async {
      when(mockNoteRemoteDataSource.getNotes())
          .thenAnswer((realInvocation) async => testNoteModelList);

      await repository.getNotes();

      verify(mockNoteRemoteDataSource.getNotes());
      verify(mockNoteLocalDataSource.cacheNotes(testNoteModelList));
    });

    test('Should return failure when remote source unavailable', () async {
      when(mockNoteRemoteDataSource.getNotes()).thenThrow(ServerException());

      final actual = await repository.getNotes();

      verify(mockNoteRemoteDataSource.getNotes());
      verifyZeroInteractions(mockNoteLocalDataSource);
      expect(actual, equals(Left(ServerFailure())));
    });
  });

  group('If device is offline', () {
    setUp(() => when(mockNetworkInfo.isConnected)
        .thenAnswer((realInvocation) async => false));
    
    test('Should get notes saved in device', () async {
      when(mockNoteLocalDataSource.getNotes()).thenAnswer((realInvocation) async => testNoteModelList);

      final actual = await repository.getNotes();

      verifyZeroInteractions(mockNoteRemoteDataSource);
      verify(mockNoteLocalDataSource.getNotes());
      expect(actual, equals(Right(testNoteModelList)));
    });

    test('Should return CacheFailure on no local storage data', () async {
      when(mockNoteLocalDataSource.getNotes()).thenThrow(CacheException());

      final actual = await repository.getNotes();

      verifyZeroInteractions(mockNoteRemoteDataSource);
      verify(mockNoteLocalDataSource.getNotes());
      expect(actual, Left(CacheFailure()));
    });
  });
  
  group('Independent of network connection status', () {
    test('Should return Note from local source', () async {
      when(mockNoteLocalDataSource.getNote(testId)).thenAnswer((realInvocation) async => testNoteModel);

      final actual = await repository.getNote(testId);

      verify(mockNoteLocalDataSource.getNote(testId));
      expect(actual, Right(testNote));
    });

    test('Should return CacheFailure if Note not found', () async {
      when(mockNoteLocalDataSource.getNote(testId)).thenThrow(CacheException());

      final actual = await repository.getNote(testId);

      verify(mockNoteLocalDataSource.getNote(testId));
      expect(actual, Left(CacheFailure()));
    });
  });
}
