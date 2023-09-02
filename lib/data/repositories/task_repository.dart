import 'package:tasks_app/data/models/task_model.dart';

import '../../core/error/exception.dart';
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
  Future<Either<Failure, Success>> deleteTask(String id) async {
    try {
      if (await networkInfo.isConnected) {
        await localDataSource.deleteTask(id);
        await remoteDataSource.deleteTask(id);
        return Right(RemoteDeleteSuccess());
      } else {
        await localDataSource.deleteTask(id);
        return Right(DeleteSuccess());
      }
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Task>> getTask(String id) async {
    try {
      final task = await localDataSource.getTask(id);
      return Right(task);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, List<Task>>> getTasks() async {
    try {
      if (await networkInfo.isConnected) {
        final remoteTasks = await remoteDataSource.getTasks();
        localDataSource.cacheTasks(remoteTasks);
        return Right(remoteTasks);
      } else {
        final tasks = await localDataSource.getTasks();
        return Right(tasks);
      }
    } on ServerException {
      return Left(ServerFailure());
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Success>> insertTask(Task task) async {
    try {
      _handleEmptyTasks(task);
      if (await networkInfo.isConnected) {
        await localDataSource.insertTask(TaskModel.fromTask(task));
        await remoteDataSource.insertTask(TaskModel.fromTask(task));
        return Right(RemoteInsertionSuccess(id: task.id));
      } else {
        return Right(InsertionSuccess(
            id: await localDataSource.insertTask(TaskModel.fromTask(task))));
      }
    } on ServerException {
      return Left(ServerFailure());
    } on EmptyTaskException {
      return Left(EmptyTaskFailure());
    }
  }

  @override
  Future<Either<Failure, List<Task>>> searchTasks(String query) async {
    try {
      return Right(await localDataSource.searchTasks(query));
    } on CacheException {
      return Left(CacheFailure());
    } on Exception {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, Success>> updateTask(Task task) async {
    try {
      _handleEmptyTasks(task);
      if(await networkInfo.isConnected) {
        await localDataSource.updateTask(TaskModel.fromTask(task));
        await remoteDataSource.updateTask(TaskModel.fromTask(task));
        return Right(RemoteUpdateSuccess());
      } else {
        await localDataSource.updateTask(TaskModel.fromTask(task));
        return Right(UpdateSuccess());
      }
    } on ServerException {
      return Left(ServerFailure());
    } on EmptyTaskException {
      return Left(EmptyTaskFailure());
    }
  }

  void _handleEmptyTasks(Task task) {
    if (task.name.trim() == '') {
      throw EmptyTaskException();
    }
  }
}
