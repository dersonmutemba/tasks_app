import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../domain/entities/note.dart';

abstract class NotePageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Load extends NotePageEvent {
  final Note? note;
  Load({this.note});

  @override
  List<Object> get props => [note!];
}

class Create extends NotePageEvent {
  final Note note;
  final Function(Failure l) onFailure;
  final Function() onSuccess;
  Create({required this.note, required this.onFailure, required this.onSuccess});

  @override
  List<Object> get props => [note];
}

class Save extends NotePageEvent {
  final Note note;
  final Function(Failure l) onFailure;
  final Function() onSuccess;
  Save({required this.note, required this.onFailure, required this.onSuccess});

  @override
  List<Object> get props => [note];
}
