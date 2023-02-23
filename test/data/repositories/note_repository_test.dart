import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tasks_app/core/platform/network_info.dart';
import 'package:tasks_app/data/datasources/note_local_data_source.dart';
import 'package:tasks_app/data/datasources/note_remote_data_source.dart';
import 'package:tasks_app/data/repositories/note_repository.dart';

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
}
