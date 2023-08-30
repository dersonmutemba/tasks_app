import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tasks_app/core/data/database.dart';
import 'package:tasks_app/core/error/exception.dart';
import 'package:tasks_app/data/datasources/task_local_data_source.dart';
import 'package:tasks_app/data/models/task_model.dart';
import 'package:tasks_app/domain/entities/task_exp.dart';

void main() {
  late Database database;
  late LocalDatabase localDatabase;
  late TaskLocalDataSourceImplementation taskLocalDataSource;
  const String taskTable = 'task';
  final TaskModel testTask = TaskModel(
      id: "210ec58a-a0f2-4ac4-8393-c866d813b8d1",
      name: 'name',
      createdAt: DateTime.parse("2023-08-20T23:50:39.242"),
      status: Status.doing);
  final List<TaskModel> testTaskList = [
    TaskModel(
        id: "110ec58a-a0f2-4ac4-8393-c866d813b8d1",
        name: 'name',
        createdAt: DateTime.parse("2023-08-20T23:50:39.242"),
        status: Status.doing),
    TaskModel(
        id: "310ec58c-a0f2-4ac4-8393-c866d813b8d1",
        name: 'name',
        createdAt: DateTime.parse("2023-08-20T23:50:39.242"),
        status: Status.doing),
    TaskModel(
        id: "160ec58a-a0f2-4ac4-8393-c866d813b8d1",
        name: 'name',
        createdAt: DateTime.parse("2023-08-20T23:50:39.242"),
        status: Status.doing),
  ];
  const String testSearchQuery = 'search';
  final List<TaskModel> testTaskListToSearch = [
    TaskModel(
        id: "110ec58a-a0f2-4ac4-8393-c866d813b8d1",
        name: 'name',
        createdAt: DateTime.parse("2023-08-20T23:50:39.242"),
        status: Status.doing),
    TaskModel(
        id: "310ec58c-a0f2-4ac4-8393-c866d813b8d1",
        name: 'search name',
        description: 'description',
        createdAt: DateTime.parse("2023-08-20T23:50:39.242"),
        status: Status.doing),
    TaskModel(
        id: "160ec58a-a0f2-4ac4-8393-c866d813b8d1",
        name: 'search name',
        description: 'search description',
        createdAt: DateTime.parse("2023-08-20T23:50:39.242"),
        status: Status.doing),
    TaskModel(
        id: "180ec58a-a0f2-4ac4-8393-c866d813b8d1",
        name: 'name',
        description: 'search description',
        createdAt: DateTime.parse("2023-08-20T23:50:39.242"),
        status: Status.doing),
  ];
  final List<TaskModel> testTaskListSearchResult = [
    TaskModel(
        id: "310ec58c-a0f2-4ac4-8393-c866d813b8d1",
        name: 'search name',
        description: 'description',
        createdAt: DateTime.parse("2023-08-20T23:50:39.242"),
        status: Status.doing),
    TaskModel(
        id: "160ec58a-a0f2-4ac4-8393-c866d813b8d1",
        name: 'search name',
        description: 'search description',
        createdAt: DateTime.parse("2023-08-20T23:50:39.242"),
        status: Status.doing),
    TaskModel(
        id: "180ec58a-a0f2-4ac4-8393-c866d813b8d1",
        name: 'name',
        description: 'search description',
        createdAt: DateTime.parse("2023-08-20T23:50:39.242"),
        status: Status.doing),
  ];
  final testTaskModel = TaskModel(
      id: "910ec58a-a0f2-4ac4-8393-c866d813b8d1",
      name: 'name',
      description: 'description',
      createdAt: DateTime.parse("2023-08-20T23:50:39.242"),
      status: Status.doing);
  final updatedTestTaskModel = TaskModel(
      id: "910ec58a-a0f2-4ac4-8393-c866d813b8d1",
      name: 'updated name',
      description: 'updated description',
      createdAt: DateTime.parse("2023-08-20T23:50:39.242"),
      status: Status.doing);

  setUpAll(() async {
    sqfliteFfiInit();
    database = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    await database.execute('''
      CREATE TABLE $taskTable(
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        icon TEXT,
        createdAt DATETIME NOT NULL,
        lastEdited DATETIME,
        startedAt DATETIME,
        dueDate DATETIME,
        status TEXT NOT NULL
      );''');
    localDatabase = LocalDatabase(taskTable, database: database);
    taskLocalDataSource = TaskLocalDataSourceImplementation(localDatabase);
  });

  group('Test Local DataSource Implementation', () {
    test('Cache TaskModel', () async {
      await taskLocalDataSource.cacheTasks(testTaskList);
      var actual = await taskLocalDataSource.getTask(testTaskList.first.id);
      expect(actual, testTaskList.first);
    });

    test('Trying to get unexisting Task', () async {
      var future = taskLocalDataSource.getTask(testTask.id);
      expectLater(future, throwsA(isA<CacheException>()));
    });


    test('Get all Tasks', () async {
      var actual = await taskLocalDataSource.getTasks();
      expect(actual, testTaskList);
    });

    test('Single Task insertion should return id', () async {
      var actual = await taskLocalDataSource.insertTask(testTaskModel);
      var matcher = testTaskModel.id;
      expect(actual, matcher);
    });

    test('Update Task', () async {
      var countBefore = (await taskLocalDataSource.getTasks()).length;
      await taskLocalDataSource.updateTask(updatedTestTaskModel);
      var countAfter = (await taskLocalDataSource.getTasks()).length;
      var actualName = (await taskLocalDataSource.getTask(updatedTestTaskModel.id)).name;
      var matcherName = updatedTestTaskModel.name;
      var actualStatus = (await taskLocalDataSource.getTask(updatedTestTaskModel.id)).status;
      var matcherStatus = updatedTestTaskModel.status;
      expect(countBefore, countAfter);
      expect(actualName, matcherName);
      expect(actualStatus, matcherStatus);
    });

    test('Delete Task', () async {
      await taskLocalDataSource.deleteTask(testTaskModel.id);
      var future = taskLocalDataSource.getTask(testTaskModel.id);
      expect(future, throwsA(isA<CacheException>()));
    });

    test('Search should return tasks containing search in order of matching', () async {
      await taskLocalDataSource.cacheTasks(testTaskListToSearch);
      var actual = await taskLocalDataSource.searchTasks(testSearchQuery);
      expect(actual, testTaskListSearchResult);
    });
  });
}
