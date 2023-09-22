import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../domain/entities/task.dart';

abstract class TaskPageEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class Load extends TaskPageEvent {
  final Task? task;
  Load({this.task});

  @override
  List<Object?> get props => [task!];
}

class Create extends TaskPageEvent {
  final Task task;
  final Function(Failure l) onFailure;
  final Function() onSuccess;
  Create(
    {required this.task, required this.onFailure, required this.onSuccess}
  );

  @override
  List<Object?> get props => [task];
}

class Delete extends TaskPageEvent {
  final String id;
  Delete(this.id);

  @override
  List<Object> get props => [id];
}

class Save extends TaskPageEvent {
  final Task task;
  final Function(Failure l) onFailure;
  final Function() onSuccess;
  Save({required this.task, required this.onFailure, required this.onSuccess});

  @override
  List<Object?> get props => [task];
}
