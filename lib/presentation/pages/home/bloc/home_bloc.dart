import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc.dart';


class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const SelectedTasksHome()) {
    on<TasksHomeSelected>((event, emit) => emit(const SelectedTasksHome()));
    on<NotesHomeSelected>((event, emit) => emit(const SelectedNotesHome()));
  }
}
