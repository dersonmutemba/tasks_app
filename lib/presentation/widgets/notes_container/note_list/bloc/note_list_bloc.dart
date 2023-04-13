import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../../../domain/usecases/get_notes.dart';
import 'bloc.dart';

class NoteListBloc extends Bloc<NoteListEvent, NoteListState> {
  final GetNotes getNotes;
  NoteListBloc({required this.getNotes}) : super(Loading()) {
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
  }
}
