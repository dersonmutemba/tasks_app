import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart' as di;
import 'bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const Loading()) {
    on<TasksHomeSelected>((event, emit) => emit(const SelectedTasksHome()));
    on<NotesHomeSelected>((event, emit) => emit(const SelectedNotesHome()));
    on<Dismiss>((event, emit) => emit(const Dismissed()));
    on<Load>((event, emit) async {
      emit(const Loading());
      await di.init();
      emit(const SelectedTasksHome());
    });
  }
}
