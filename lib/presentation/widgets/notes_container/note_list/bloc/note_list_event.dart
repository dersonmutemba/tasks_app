import 'package:equatable/equatable.dart';

abstract class NoteListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class Load extends NoteListEvent {}

class Search extends NoteListEvent {
  final String query;
  Search(this.query);

  @override
  List<Object> get props => [query];
}
