import 'package:equatable/equatable.dart';

abstract class TaskListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class Load extends TaskListEvent {}

class Search extends TaskListEvent {
  final String query;
  Search(this.query);

  @override
  List<Object?> get props => [query];
}
