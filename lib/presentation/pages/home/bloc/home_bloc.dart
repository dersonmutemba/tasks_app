import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const SelectedTasksHome()) {
    on<TasksHomeSelected>((event, emit) async {
      emit(const SelectingTasksHome());
      await Future.delayed(
          const Duration(milliseconds: 10), () => emit(const SelectedTasksHome()));
    });
    on<NotesHomeSelected>((event, emit) async {
      emit(const SelectingNotesHome());
      await Future.delayed(
          const Duration(milliseconds: 10), () => emit(const SelectedNotesHome()));
    });
  }
}
