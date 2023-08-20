import '../models/task_model.dart';

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
  @override
  Future<void> cacheTasks(List<TaskModel> tasks) {
    // TODO: implement cacheTasks
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTask(String id) {
    // TODO: implement deleteTask
    throw UnimplementedError();
  }

  @override
  Future<TaskModel> getTask(String id) {
    // TODO: implement getTask
    throw UnimplementedError();
  }

  @override
  Future<List<TaskModel>> getTasks() {
    // TODO: implement getTasks
    throw UnimplementedError();
  }

  @override
  Future<String> insertTask(TaskModel task) {
    // TODO: implement insertTask
    throw UnimplementedError();
  }

  @override
  Future<List<TaskModel>> searchTasks(String query) {
    // TODO: implement searchTasks
    throw UnimplementedError();
  }

  @override
  Future<void> updateTask(TaskModel task) {
    // TODO: implement updateTask
    throw UnimplementedError();
  }

}