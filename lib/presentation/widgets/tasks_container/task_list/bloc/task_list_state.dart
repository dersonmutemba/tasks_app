import 'package:equatable/equatable.dart';

import '../../../../../domain/entities/task.dart';

abstract class TaskListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Loading extends TaskListState {}

class Empty extends TaskListState {}

class NotFound extends TaskListState {}

class Error extends TaskListState {
  final String message;
  Error({required this.message});

  @override
  List<Object?> get props => [message];
}

class Loaded extends TaskListState {
  final List<Task> tasks;
  Loaded(this.tasks);

  @override
  List<Object?> get props => [tasks];
}
