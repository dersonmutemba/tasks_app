import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/usecases/insert_note.dart' as insert_note;
import '../../../../domain/usecases/update_note.dart' as update_note;
import 'bloc.dart';

class NotePageBloc extends Bloc<NotePageEvent, NotePageState> {
  final insert_note.InsertNote insertNote;
  final update_note.UpdateNote updateNote;
  NotePageBloc({required this.insertNote, required this.updateNote})
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
    emit(Saving());
    var response = await insertNote(insert_note.Params(note: event.note));
    response.fold((l) {
      event.onFailure(l);
      emit(Error(message: 'Note not saved'));
    }, (r) {
      event.onSuccess();
      emit(Saved(message: 'Note saved successfully'));
    }, (r) {
      event.onSuccess();
      emit(Error(message: 'Note not saved'));
    });
  }

  void _saveNote(Save event, emit) async {
    emit(Saving());
    var response = await updateNote(update_note.Params(note: event.note));
    response.fold((l) {
      event.onFailure(l);
      emit(Error(message: 'Note not saved'));
    }, (r) {
      event.onSuccess();
      emit(Saved(message: 'Note saved successfully'));
    });
  }
}
