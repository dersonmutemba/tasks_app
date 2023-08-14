import 'package:tasks_app/interfaces/dartz.dart';

import '../../core/error/failure.dart';
import '../../core/success/success.dart';
import '../../core/usecases/usecase.dart';
import '../contracts/task_contract.dart';

class DeleteTask extends UseCase<Success, Params> {
  final TaskContract contract;
  DeleteTask(this.contract);

  @override
  Future<Either<Failure, Success>> call(Params params) async =>
      contract.deleteTask(params.id);
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
