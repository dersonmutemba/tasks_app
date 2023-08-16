import 'package:tasks_app/interfaces/dartz.dart';

import '../../core/error/failure.dart';
import '../../core/success/success.dart';
import '../../core/usecases/usecase.dart';
import '../contracts/task_contract.dart';
import '../entities/task.dart';

class InsertTask extends UseCase<Success, Params> {
  final TaskContract contract;
  InsertTask(this.contract);

  @override
  Future<Either<Failure, Success>> call(Params params) async =>
      contract.insertTask(params.task);
}

class Params {
  final Task task;
  Params({required this.task});

  @override
  bool operator ==(Object other) =>
      other is Params && other.runtimeType == runtimeType && other.task == task;

  @override
  int get hashCode => task.hashCode;
}
