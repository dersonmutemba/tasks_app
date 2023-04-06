import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/success/success.dart';
import '../../../../domain/contracts/note_contract.dart';
import '../../../../domain/entities/note.dart';
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
    if (event.id != null) {
      var result = await noteRepository.getNote(event.id!);
      result.fold((l) {
        emit(Error(message: 'Could not find specified Note'));
      }, (r) {
        emit(Editing(note: r));
      });
    } else {
      emit(Creating());
    }
  }

  void _createNote(Create event, emit) async {
    emit(Creating());
    if (event.noteProps['title'] == null ||
        event.noteProps['content'] == null) {
      emit(Error(message: 'One of the fields is empty'));
    } else {
      var response = await noteRepository.insertNote(Note(
          id: const Uuid().v1(),
          title: event.noteProps['title'],
          content: event.noteProps['content'],
          createdAt: event.noteProps['date'],
          lastEdited: DateTime.now()));
      response.fold(
        (l) {
          if (l is ServerFailure) {
            emit(Error(message: 'Server error'));
          } else if (l is CacheFailure) {
            emit(Error(message: 'Database error'));
          }
        },
        (r) {
          if(r is InsertionSuccess) {
            emit(Saved(message: 'Note saved successfully'));
          }
        }
      );
    }
  }

  void _saveNote(Save event, emit) async {
    emit(Saving());
    // TODO: Add logic for saving notes
    emit(Error(message: 'Logic not created yet'));
  }
}
