import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/success/success.dart';
import '../../../../domain/contracts/note_contract.dart';
import '../../../../domain/entities/note.dart';
import 'bloc.dart';

class NotePageBloc extends Bloc<NotePageEvent, NotePageState> {
  final NoteContract noteRepository;
  late final String? id;
  NotePageBloc({required this.noteRepository, this.id})
      : super(id != null ? Loading(id: id) : Creating()) {
    on<Load>(_loadNote);
    on<Save>(_saveNote);
  }

  void _loadNote(Load event, emit) async {
    if (id != null) {
      var result = await noteRepository.getNote(id!);
      result.fold((l) {
        emit(Error(message: 'Could not find specified Note'));
      }, (r) {
        emit(Editing(note: r));
      });
    }
  }

  void _saveNote(Save event, emit) async {
    emit(Saving());
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
            id = r.id;
          }
          emit(Saved(message: 'Note saved successfully'));
        }
      );
    }
  }
}
