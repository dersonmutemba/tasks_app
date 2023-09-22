import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/usecases/delete_task.dart' as delete_task;
import '../../../../domain/usecases/insert_task.dart' as insert_task;
import '../../../../domain/usecases/update_task.dart' as update_task;
import 'bloc.dart';

class TaskPageBloc extends Bloc<TaskPageEvent, TaskPageState> {
  final delete_task.DeleteTask deleteTask;
  final insert_task.InsertTask insertTask;
  final update_task.UpdateTask updateTask;
  TaskPageBloc({required this.deleteTask, required this.insertTask, required this.updateTask})
      : super(Loading()) {
    on<Load>(_loadTask);
    on<Create>(_createTask);
    on<Delete>(_deleteTask);
    on<Save>(_saveTask);
  }

  void _loadTask(Load event, emit) async {
    if (event.task != null) {
      emit(Editing(task: event.task!));
    } else {
      emit(Creating());
    }
  }

  void _createTask(Create event, emit) async {
    emit(Saving());
    var response = await insertTask(insert_task.Params(task: event.task));
    response.fold((l) {
      event.onFailure(l);
      emit(Error(message: 'Task not saved'));
    }, (r) {
      event.onSuccess();
      emit(Saved(message: 'Task saved successfully'));
    });
  }

  void _deleteTask(Delete event, emit) async {
    emit(Deleting());
    var response = await deleteTask(delete_task.Params(id: event.id));
    response.fold((l) {
      emit(Error(message: 'Task not deleted'));
    }, (r) {
      emit(Loading());
    });
  }

  void _saveTask(Save event, emit) async {
    emit(Saving());
    var response = await updateTask(update_task.Params(task: event.task));
    response.fold((l) {
      event.onFailure(l);
      emit(Error(message: 'Task not saved'));
    }, (r) {
      event.onSuccess();
      emit(Saved(message: 'Task saved successfully'));
    });
  }
}