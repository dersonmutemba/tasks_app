import '../../core/error/failure.dart';
import '../../core/success/success.dart';
import '../../core/usecases/usecase.dart';
import '../../interfaces/dartz.dart';
import '../contracts/task_contract.dart';
import '../entities/task.dart';

class UpdateTask extends UseCase<Success, Params> {
  final TaskContract contract;
  UpdateTask(this.contract);

  @override
  Future<Either<Failure, Success>> call(Params params) async =>
      contract.updateTask(params.task);
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
