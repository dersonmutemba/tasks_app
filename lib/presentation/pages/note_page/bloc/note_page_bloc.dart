import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks_app/core/error/failure.dart';
import 'package:uuid/uuid.dart';

import '../../../../data/repositories/note_repository.dart';
import '../../../../domain/entities/note.dart';
import 'bloc.dart';

class NotePageBloc extends Bloc<NotePageEvent, NotePageState> {
  final NoteRepository noteRepository;
  final String? id;
  NotePageBloc({required this.noteRepository, this.id})
      : super(id != null ? Loading(id: id) : Creating()) {
    on<Save>(_saveNote);
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
        (r) => emit(Saved()),
      );
    }
  }
}
