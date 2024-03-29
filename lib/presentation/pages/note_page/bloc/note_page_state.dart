import 'package:equatable/equatable.dart';

import '../../../../domain/entities/note.dart';

abstract class NotePageState extends Equatable {
  @override
  List<Object> get props => [];
}

class Loading extends NotePageState {
  final Note? note;
  Loading({this.note});

  @override
  List<Object> get props => [note!];
}

class Creating extends NotePageState {}

class Deleting extends NotePageState {}

class Editing extends NotePageState {
  final Note note;
  Editing({required this.note});

  @override
  List<Object> get props => [note];
}

class Saving extends NotePageState {}

class Saved extends NotePageState {
  final String message;
  Saved({required this.message});

  @override
  List<Object> get props => [message];
}

class Error extends NotePageState {
  final String message;
  Error({required this.message});

  @override
  List<Object> get props => [message];
}
