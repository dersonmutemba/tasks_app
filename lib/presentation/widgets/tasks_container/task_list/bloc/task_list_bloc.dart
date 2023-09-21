import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../../../domain/usecases/get_tasks.dart';
import '../../../../../domain/usecases/search_tasks.dart';
import 'bloc.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  final GetTasks getTasks;
  final SearchTasks searchTasks;
  TaskListBloc({required this.getTasks, required this.searchTasks})
      : super(Loading()) {
    on<Load>(
      (event, emit) async {
        emit(Loading());
        var result = await getTasks(NoParams());
        result.fold((l) {
          if (l is ServerFailure) {
            emit(Error(message: 'Server Error'));
          } else if (l is CacheFailure) {
            emit(Error(message: 'Local Database Error'));
          } else {
            emit(Error(message: 'Unknown Error'));
          }
        }, (r) {
          if (r.isEmpty) {
            emit(Empty());
          } else {
            emit(Loaded(r));
          }
        });
      },
    );

    on<Search>(
      (event, emit) async {
        var result = await searchTasks(Params(query: event.query));
        result.fold((l) {
          if (l is CacheFailure) {
            emit(Error(message: 'Local Database Error'));
          } else {
            emit(Error(message: 'Unknown Error'));
          }
        }, (r) {
          if (r.isEmpty) {
            emit(NotFound());
          } else {
            emit(Loaded(r));
          }
        });
      },
    );
  }
}
