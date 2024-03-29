import 'package:tasks_app/interfaces/dartz.dart';

import '../../core/error/failure.dart';
import '../../core/usecases/usecase.dart';
import '../contracts/task_contract.dart';
import '../entities/task.dart';

class GetTask extends UseCase<Task, Params> {
  final TaskContract contract;
  GetTask(this.contract);

  @override
  Future<Either<Failure, Task>> call(Params params) async =>
      contract.getTask(params.id);
}

class Params {
  final String id;
  Params({required this.id});

  @override
  bool operator ==(Object other) =>
      other is Params && other.runtimeType == runtimeType && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
