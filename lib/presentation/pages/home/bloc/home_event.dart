import 'package:equatable/equatable.dart';

class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class TasksHomeSelected extends HomeEvent {}

class NotesHomeSelected extends HomeEvent {}
