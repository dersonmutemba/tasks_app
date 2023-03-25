import 'package:equatable/equatable.dart';

abstract class NotePageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Load extends NotePageEvent {}

class Save extends NotePageEvent {
  final Map<String, dynamic> noteProps;
  Save({required this.noteProps});

  @override
  List<Object> get props => [noteProps];
}
