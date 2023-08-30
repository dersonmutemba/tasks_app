import '../../core/error/failure.dart';
import '../../core/network/network_info.dart';
import '../../core/success/success.dart';
import '../../domain/contracts/task_contract.dart';
import '../../domain/entities/task.dart';
import '../../interfaces/dartz.dart';
import '../datasources/task_local_data_source.dart';
import '../datasources/task_remote_data_source.dart';

class TaskRepository implements TaskContract {
  final TaskRemoteDataSource remoteDataSource;
  final TaskLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  TaskRepository(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, Success>> deleteTask(String id) {
    // TODO: implement deleteTask
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Task>> getTask(String id) {
    // TODO: implement getTask
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Task>>> getTasks() {
    // TODO: implement getTasks
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Success>> insertTask(Task task) {
    // TODO: implement insertTask
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Task>>> searchTasks(String query) {
    // TODO: implement searchTasks
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Success>> updateTask(Task task) {
    // TODO: implement updateTask
    throw UnimplementedError();
  }
}
