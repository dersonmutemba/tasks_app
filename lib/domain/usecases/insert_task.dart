import 'package:dartz/dartz.dart';

import '../../core/error/failure.dart';
import '../../core/success/success.dart';
import '../../core/usecases/usecase.dart';
import '../contracts/task_contract.dart';
import '../entities/task.dart' as task_object;

class InsertTask extends UseCase<Success, Params> {
  final TaskContract contract;
  InsertTask(this.contract);

  @override
  Future<Either<Failure, Success>> call(Params params) async =>
      contract.insertTask(params.task);
}

class Params {
  final task_object.Task task;
  Params({required this.task});

  @override
  bool operator ==(Object other) =>
      other is Params && other.runtimeType == runtimeType && other.task == task;

  @override
  int get hashCode => task.hashCode;
}
