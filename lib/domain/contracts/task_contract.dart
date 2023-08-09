import 'package:dartz/dartz.dart';

import '../../core/error/failure.dart';
import '../entities/task.dart' as task;

abstract class TaskContract {
  Future<Either<Failure, List<task.Task>>> getTasks();
  Future<Either<Failure, task.Task>> getTask(String id);
}
