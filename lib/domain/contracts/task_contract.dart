import 'package:tasks_app/interfaces/dartz.dart';

import '../../core/error/failure.dart';
import '../../core/success/success.dart';
import '../entities/task.dart';

abstract class TaskContract {
  Future<Either<Failure, Success>> insertTask(Task task);
  Future<Either<Failure, List<Task>>> getTasks();
  Future<Either<Failure, Task>> getTask(String id);
  Future<Either<Failure, Success>> updateTask(Task task);
}
