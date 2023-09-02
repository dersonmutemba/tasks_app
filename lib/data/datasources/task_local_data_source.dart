import '../../core/data/database.dart';
import '../../core/error/exception.dart';
import '../models/task_model.dart';
import 'datasources_constants.dart';

abstract class TaskLocalDataSource {
  Future<TaskModel> getTask(String id);

  Future<List<TaskModel>> getTasks();

  Future<void> cacheTasks(List<TaskModel> tasks);

  Future<String> insertTask(TaskModel task);

  Future<void> updateTask(TaskModel task);

  Future<void> deleteTask(String id);

  Future<List<TaskModel>> searchTasks(String query);
}

class TaskLocalDataSourceImplementation implements TaskLocalDataSource {
  LocalDatabase localDatabase;
  final String table = datasourcesConstants['taskTable'];
  final List<String> columns = datasourcesConstants['taskColumns'];
  TaskLocalDataSourceImplementation(this.localDatabase);

  @override
  Future<void> cacheTasks(List<TaskModel> tasks) async {
    List<Map<String, dynamic>> valuesList = [];
    for (var task in tasks) {
      valuesList.add(task.toJson());
    }
    await localDatabase.insert(table, valuesList);
  }

  @override
  Future<void> deleteTask(String id) async {
    await localDatabase.delete(table, [columns.first], [id]);
  }

  @override
  Future<TaskModel> getTask(String id) async {
    var result = await localDatabase.getObjects(
        table, [columns.first], [id], columns.sublist(1));
    if (result != null) {
      return TaskModel.fromJson(result.first);
    }
    throw CacheException();
  }

  @override
  Future<List<TaskModel>> getTasks() async {
    var results = await localDatabase.getAllObjects(table);
    if (results != null) {
      List<TaskModel> tasks = [];
      for (var result in results) {
        tasks.add(TaskModel.fromJson(result));
      }
      return tasks;
    }
    throw CacheException();
  }

  @override
  Future<String> insertTask(TaskModel task) async {
    localDatabase.insert(table, [task.toJson()]);
    return task.id;
  }

  @override
  Future<List<TaskModel>> searchTasks(String query) async {
    var results = await localDatabase.searchObjects(
        table,
        columns.sublist(1, 3)..add(columns.last),
        query,
        columns.sublist(3, columns.length - 1)..add(columns[0]));
    if (results != null) {
      List<TaskModel> tasks = [];
      for (var result in results) {
        tasks.add(TaskModel.fromJson(result));
      }
      return tasks;
    }
    return [];
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    await localDatabase
        .update(table, task.toJson(), [columns.first], [task.id]);
  }
}
