import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/contracts/note_contract.dart';
import 'bloc.dart';

class NotePageBloc extends Bloc<NotePageEvent, NotePageState> {
  final NoteContract noteRepository;
  NotePageBloc({required this.noteRepository})
      : super(Loading()) {
    on<Load>(_loadNote);
    on<Create>(_createNote);
    on<Save>(_saveNote);
  }

  void _loadNote(Load event, emit) async {
    if (event.note != null) {
      emit(Editing(note: event.note!));
    } else {
      emit(Creating());
    }
  }

  void _createNote(Create event, emit) async {
    emit(Creating());
    // TODO: Add logic for saving notes periodically
    emit(Error(message: 'Logic not created yet'));
  }

  void _saveNote(Save event, emit) async {
    emit(Saving());
    // TODO: Add logic for saving notes periodically
    emit(Error(message: 'Logic not created yet'));
  }
}
