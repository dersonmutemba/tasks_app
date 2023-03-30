import 'package:equatable/equatable.dart';

import '../../../../domain/entities/note.dart';

abstract class NotePageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Load extends NotePageEvent {}

class Create extends NotePageEvent {
  final Map<String, dynamic> noteProps;
  Create({required this.noteProps});

  @override
  List<Object> get props => [noteProps];
}

class Save extends NotePageEvent {
  final Note note;
  Save({required this.note});

  @override
  List<Object> get props => [note];
}