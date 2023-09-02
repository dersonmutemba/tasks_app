import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tasks_app/core/error/exception.dart';
import 'package:tasks_app/core/error/failure.dart';
import 'package:tasks_app/core/network/network_info.dart';
import 'package:tasks_app/core/success/success.dart';
import 'package:tasks_app/data/datasources/task_local_data_source.dart';
import 'package:tasks_app/data/datasources/task_remote_data_source.dart';
import 'package:tasks_app/data/models/task_model.dart';
import 'package:tasks_app/data/repositories/task_repository.dart';
import 'package:tasks_app/domain/entities/task_exp.dart';
import 'package:tasks_app/interfaces/dartz.dart';

import 'task_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<NetworkInfo>()])
@GenerateNiceMocks([MockSpec<TaskLocalDataSource>()])
@GenerateNiceMocks([MockSpec<TaskRemoteDataSource>()])
void main() {
  late TaskRepository repository;
  late MockTaskRemoteDataSource mockTaskRemoteDataSource;
  late MockTaskLocalDataSource mockTaskLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockTaskRemoteDataSource = MockTaskRemoteDataSource();
    mockTaskLocalDataSource = MockTaskLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = TaskRepository(
        remoteDataSource: mockTaskRemoteDataSource,
        localDataSource: mockTaskLocalDataSource,
        networkInfo: mockNetworkInfo);
  });

  const String testId = "210ec58a-a0f2-4ac4-8393-c866d813b8d1";
  const String testSearchQuery = "name";
  final TaskModel testTaskModel = TaskModel(
      id: "210ec58a-a0f2-4ac4-8393-c866d813b8d1",
      name: 'name',
      createdAt: DateTime.parse("2023-08-20T23:50:39.242"),
      status: Status.doing);
  final updatedTestTaskModel = TaskModel(
      id: "210ec58a-a0f2-4ac4-8393-c866d813b8d1",
      name: 'updated name',
      description: 'description',
      createdAt: DateTime.parse("2023-08-20T23:50:39.242"),
      status: Status.doing);
  final updatedEmptyTaskModel = TaskModel(
      id: "210ec58a-a0f2-4ac4-8393-c866d813b8d1",
      name: '',
      createdAt: DateTime.parse("2023-08-20T23:50:39.242"),
      status: Status.doing);
  final emptyTaskModel = TaskModel(
      id: "210ec58a-a0f2-4ac4-8393-c866d813b8d2",
      name: '',
      createdAt: DateTime.parse("2023-08-20T23:50:39.242"),
      status: Status.doing);
  final emptyTaskModel2 = TaskModel(
      id: "210ec58a-a0f2-4ac4-8393-c866d813b8d3",
      name: '   ',
      createdAt: DateTime.parse("2023-08-20T23:50:39.242"),
      status: Status.doing);
  final testTaskModelList = [testTaskModel];
  final Task testTask = testTaskModel;

  test('Should check if device is offline', () {
    when(mockNetworkInfo.isConnected)
        .thenAnswer((realInvocation) async => true);

    repository.getTasks();

    verify(mockNetworkInfo.isConnected);
  });

  group('If device is online', () {
    setUp(() => when(mockNetworkInfo.isConnected)
        .thenAnswer((realInvocation) async => true));

    test('Should return remote data', () async {
      when(mockTaskRemoteDataSource.getTasks())
          .thenAnswer((realInvocation) async => testTaskModelList);

      final actual = await repository.getTasks();

      verify(mockTaskRemoteDataSource.getTasks());
      expect(actual, equals(Right(testTaskModelList)));
    });

    test('Should save data offline is successfully get data from remote source',
        () async {
      when(mockTaskRemoteDataSource.getTasks())
          .thenAnswer((realInvocation) async => testTaskModelList);

      await repository.getTasks();

      verify(mockTaskRemoteDataSource.getTasks());
      verify(mockTaskLocalDataSource.cacheTasks(testTaskModelList));
    });

    test('Should return failure when remote source unavailable', () async {
      when(mockTaskRemoteDataSource.getTasks()).thenThrow(ServerException());

      final actual = await repository.getTasks();

      verify(mockTaskRemoteDataSource.getTasks());
      verifyZeroInteractions(mockTaskLocalDataSource);
      expect(actual, equals(Left(ServerFailure())));
    });

    test(
        'Should attempt to insert in local database before attempting to insert remotely',
        () async {
      when(mockTaskRemoteDataSource.insertTask(testTaskModel)).thenAnswer(
          (realInvocation) async =>
              Right(RemoteInsertionSuccess(id: testTaskModel.id)));

      await repository.insertTask(testTaskModel);

      verify(mockTaskLocalDataSource.insertTask(testTaskModel));

      when(mockTaskRemoteDataSource.insertTask(testTaskModel))
          .thenAnswer((realInvocation) async => Left(ServerFailure()));

      await repository.insertTask(testTaskModel);

      verify(mockTaskLocalDataSource.insertTask(testTaskModel));
    });

    test('Should insert tasks successfully', () async {
      when(mockTaskRemoteDataSource.insertTask(testTaskModel)).thenAnswer(
          (realInvocation) async =>
              Right(RemoteInsertionSuccess(id: testTaskModel.id)));

      final actual = await repository.insertTask(testTaskModel);

      expect(actual, Right(RemoteInsertionSuccess(id: testTaskModel.id)));
      verify(mockTaskLocalDataSource.insertTask(testTaskModel));
      verify(mockTaskRemoteDataSource.insertTask(testTaskModel));
      verifyNoMoreInteractions(mockTaskLocalDataSource);
      verifyNoMoreInteractions(mockTaskRemoteDataSource);
    });

    test(
        'Should attempt to update in local database before attempting to update remotely',
        () async {
      when(mockTaskRemoteDataSource.updateTask(updatedTestTaskModel))
          .thenAnswer((realInvocation) async => Right(RemoteUpdateSuccess()));

      await repository.updateTask(updatedTestTaskModel);

      verify(mockTaskLocalDataSource.updateTask(updatedTestTaskModel));

      when(mockTaskRemoteDataSource.updateTask(updatedTestTaskModel))
          .thenAnswer((realInvocation) async => Left(ServerFailure()));

      await repository.updateTask(updatedTestTaskModel);

      verify(mockTaskLocalDataSource.updateTask(updatedTestTaskModel));
    });

    test('Should update tasks successfully', () async {
      when(mockTaskRemoteDataSource.updateTask(updatedTestTaskModel))
          .thenAnswer((realInvocation) async => Right(RemoteUpdateSuccess()));

      final actual = await repository.updateTask(updatedTestTaskModel);

      expect(actual, Right(RemoteUpdateSuccess()));

      verify(mockTaskLocalDataSource.updateTask(updatedTestTaskModel));
      verify(mockTaskRemoteDataSource.updateTask(updatedTestTaskModel));
      verifyNoMoreInteractions(mockTaskLocalDataSource);
      verifyNoMoreInteractions(mockTaskRemoteDataSource);
    });

    test(
        'Should attempt to delete in local database before attempting to delete remotely',
        () async {
      when(mockTaskRemoteDataSource.deleteTask(testId))
          .thenAnswer((realInvocation) async => Right(RemoteDeleteSuccess()));

      await repository.deleteTask(testId);

      verify(mockTaskLocalDataSource.deleteTask(testId));

      when(mockTaskRemoteDataSource.deleteTask(testId))
          .thenAnswer((realInvocation) async => Left(ServerFailure()));

      await repository.deleteTask(testId);

      verify(mockTaskLocalDataSource.deleteTask(testId));
    });

    test('Should delete tasks successfully', () async {
      when(mockTaskRemoteDataSource.deleteTask(testId))
          .thenAnswer((realInvocation) async => Right(RemoteDeleteSuccess()));

      final actual = await repository.deleteTask(testId);

      expect(actual, Right(RemoteDeleteSuccess()));

      verify(mockTaskLocalDataSource.deleteTask(testId));
      verify(mockTaskRemoteDataSource.deleteTask(testId));
      verifyNoMoreInteractions(mockTaskLocalDataSource);
      verifyNoMoreInteractions(mockTaskRemoteDataSource);
    });
  });

  group('If device is offline', () {
    setUp(() => when(mockNetworkInfo.isConnected)
        .thenAnswer((realInvocation) async => false));

    test('Should get notes saved in device', () async {
      when(mockTaskLocalDataSource.getTasks())
          .thenAnswer((realInvocation) async => testTaskModelList);

      final actual = await repository.getTasks();

      verifyZeroInteractions(mockTaskRemoteDataSource);
      verify(mockTaskLocalDataSource.getTasks());
      expect(actual, Right(testTaskModelList));
    });

    test('Should return CacheFailure on no local storage data', () async {
      when(mockTaskLocalDataSource.getTasks()).thenThrow(CacheException());

      final actual = await repository.getTasks();

      verifyZeroInteractions(mockTaskRemoteDataSource);
      verify(mockTaskLocalDataSource.getTasks());
      expect(actual, Left(CacheFailure()));
    });
  });

  group('Independent of network connection status', () {
    test('Should return Task from local source', () async {
      when(mockTaskLocalDataSource.getTask(testId))
          .thenAnswer((realInvocation) async => testTaskModel);

      final actual = await repository.getTask(testId);

      verify(mockTaskLocalDataSource.getTask(testId));
      expect(actual, Right(testTask));
    });

    test('Should search tasks from local source', () async {
      when(mockTaskLocalDataSource.searchTasks(testSearchQuery))
          .thenAnswer((realInvocation) async => testTaskModelList);

      final actual = await repository.searchTasks(testSearchQuery);

      verify(mockTaskLocalDataSource.searchTasks(testSearchQuery));
      expect(actual, Right(testTaskModelList));
    });

    test('Should return CacheFailure if Task not found', () async {
      when(mockTaskLocalDataSource.getTask(testId)).thenThrow(CacheException());

      final actual = await repository.getTask(testId);

      verify(mockTaskLocalDataSource.getTask(testId));
      expect(actual, Left(CacheFailure()));
    });

    test('Should save task to device', () async {
      when(mockTaskLocalDataSource.insertTask(testTaskModel))
          .thenAnswer((realInvocation) async => Future(() => testTaskModel.id));

      final actual = await repository.insertTask(testTaskModel);

      verify(mockTaskLocalDataSource.insertTask(testTaskModel));
      expect(actual, Right(InsertionSuccess(id: testTaskModel.id)));
    });

    test('Should return EmptyTaskFailure if Task is empty', () async {
      final actual = await repository.insertTask(emptyTaskModel);
      expect(actual, Left(EmptyTaskFailure()));
    });

    test('Should return EmptyTaskFailure if Task has only spaces', () async {
      final actual = await repository.insertTask(emptyTaskModel2);
      expect(actual, Left(EmptyTaskFailure()));
    });

    test('Shoud update task in device', () async {
      when(mockTaskLocalDataSource.updateTask(updatedTestTaskModel))
          .thenAnswer((realInvocation) async => Right(UpdateSuccess()));

      final actual = await repository.updateTask(updatedTestTaskModel);

      verify(mockTaskLocalDataSource.updateTask(updatedTestTaskModel));
      expect(actual, Right(UpdateSuccess()));
    });

    test('Should delete task in device', () async {
      when(mockTaskLocalDataSource.deleteTask(testId))
          .thenAnswer((realInvocation) async => Right(DeleteSuccess()));
      
      final actual = await repository.deleteTask(testId);

      verify(mockTaskLocalDataSource.deleteTask(testId));
      expect(actual, Right(DeleteSuccess()));
    });

    test('Should return EmptyTaskFailure if updating Task with only spaces', () async {
      final actual = await repository.updateTask(updatedEmptyTaskModel);
      expect(actual, Left(EmptyTaskFailure()));
    });
  });
}
