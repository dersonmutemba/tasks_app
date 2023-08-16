import 'package:tasks_app/interfaces/dartz.dart';

import '../../core/error/failure.dart';
import '../../core/usecases/usecase.dart';
import '../contracts/task_contract.dart';
import '../entities/task.dart';

class GetTasks extends UseCase<List<Task>, NoParams> {
  final TaskContract contract;
  GetTasks(this.contract);

  @override
  Future<Either<Failure, List<Task>>> call(NoParams params) async {
    return await contract.getTasks();
  }
}