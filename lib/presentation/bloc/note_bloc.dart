import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks_app/core/usecases/usecase.dart';

import '../../core/error/failure.dart';
import '../../domain/usecases/get_note.dart';
import '../../domain/usecases/get_notes.dart';
import 'bloc.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final GetNote getNote;
  final GetNotes getNotes;
  NoteBloc({required this.getNote, required this.getNotes}) : super(Loading());

  NoteState get initialState => Loading();

  Stream<NoteState> mapEventToState(NoteEvent event) async* {
    if (event is GetNotes) {
      yield Loading();
      final failureOrNotes = await getNotes(NoParams());
      yield failureOrNotes.fold(
          (failure) => Error(message: _mapFailureToMessage(failure)),
          (notes) => Loaded());
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return serverFailureText;
      case CacheFailure:
        return localDatabaseFailureText;
      default:
        return 'Unknown Failure';
    }
  }
}

const String serverFailureText = 'Remote Server Failure';
const String localDatabaseFailureText = 'Local Database Failure';
