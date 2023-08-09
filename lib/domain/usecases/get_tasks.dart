import 'package:dartz/dartz.dart';

import '../../core/error/failure.dart';
import '../../core/usecases/usecase.dart';
import '../contracts/task_contract.dart';
import '../entities/task.dart' as task;

class GetTasks extends UseCase<List<task.Task>, NoParams> {
  final TaskContract contract;
  GetTasks(this.contract);

  @override
  Future<Either<Failure, List<task.Task>>> call(NoParams params) async {
    return await contract.getTasks();
  }
}