import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../../../domain/usecases/get_notes.dart';
import '../../../../../domain/usecases/search_notes.dart';
import 'bloc.dart';

class NoteListBloc extends Bloc<NoteListEvent, NoteListState> {
  final GetNotes getNotes;
  final SearchNotes searchNotes;
  NoteListBloc({required this.getNotes, required this.searchNotes})
      : super(Loading()) {
    on<Load>(
      (event, emit) async {
        emit(Loading());
        var result = await getNotes(NoParams());
        result.fold((l) {
          if (l is ServerFailure) {
            emit(Error(message: 'Server Error'));
          } else if (l is CacheFailure) {
            emit(Error(message: 'Local Database Error'));
          } else {
            emit(Error(message: 'Unknown Error'));
          }
        }, (r) {
          if (r.isEmpty) {
            emit(Empty());
          } else {
            emit(Loaded(r));
          }
        });
      },
    );

    on<Search>(
      (event, emit) async {
        var result = await searchNotes(Params(query: event.query));
        result.fold((l) {
          if (l is CacheFailure) {
            emit(Error(message: 'Local Database Error'));
          } else {
            emit(Error(message: 'Unknown Error'));
          }
        }, (r) {
          if (r.isEmpty) {
            emit(Empty());
          } else {
            emit(Loaded(r));
          }
        });
      },
    );
  }
}
