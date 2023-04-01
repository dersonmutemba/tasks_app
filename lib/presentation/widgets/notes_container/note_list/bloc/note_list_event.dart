import 'package:equatable/equatable.dart';

abstract class NoteListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Load extends NoteListEvent {}
