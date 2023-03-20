import 'package:equatable/equatable.dart';

abstract class NotePageState extends Equatable {
  @override
  List<Object> get props => [];
}

class Loading extends NotePageState {
  final String? id;
  Loading({this.id});

  @override
  List<Object> get props => [id!];
}

class Creating extends NotePageState {}

class Editing extends NotePageState {
  final String id;
  Editing({required this.id});

  @override
  List<Object> get props => [id];
}

class Saving extends NotePageState {}

class Saved extends NotePageState {}

class Error extends NotePageState {
  final String message;
  Error({required this.message});

  @override
  List<Object> get props => [message];
}
