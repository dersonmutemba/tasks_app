import 'package:equatable/equatable.dart';

import '../../../../domain/entities/task.dart';

abstract class TaskPageState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Loading extends TaskPageState {
  final Task? task;
  Loading({this.task});

  @override
  List<Object?> get props => [task!];
}

class Creating extends TaskPageState {}

class Deleting extends TaskPageState {}

class Editing extends TaskPageState {
  final Task task;
  Editing({required this.task});

  @override
  List<Object?> get props => [task];
}

class Saving extends TaskPageState {}

class Saved extends TaskPageState {
  final String message;
  Saved({required this.message});

  @override
  List<Object?> get props => [props];
}

class Error extends TaskPageState {
  final String message;
  Error({required this.message});

  @override
  List<Object?> get props => [message];
}
