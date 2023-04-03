import 'package:equatable/equatable.dart';

import '../../../../../domain/entities/note.dart';

abstract class NoteListState extends Equatable {
  @override
  List<Object> get props => [];
}

class Loading extends NoteListState {}

class Empty extends NoteListState {}

class Error extends NoteListState {
  final String message;
  Error({required this.message});

  @override
  List<Object> get props => [message];
}

class Loaded extends NoteListState {
  final List<Note> notes;
  Loaded(this.notes);

  @override
  List<Object> get props => [notes];
}
