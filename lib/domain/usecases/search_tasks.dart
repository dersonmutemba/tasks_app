import '../../core/error/failure.dart';
import '../../core/usecases/usecase.dart';
import '../../interfaces/dartz.dart';
import '../contracts/task_contract.dart';
import '../entities/task.dart';

class SearchTasks extends UseCase<List<Task>, Params> {
  final TaskContract contract;
  SearchTasks(this.contract);

  @override
  Future<Either<Failure, List<Task>>> call(Params params) async =>
      await contract.searchTasks(params.query);
}

class Params {
  final String query;
  Params({required this.query});

  @override
  bool operator ==(Object other) =>
      other is Params &&
      other.runtimeType == runtimeType &&
      other.query == query;

  @override
  int get hashCode => query.hashCode;
}