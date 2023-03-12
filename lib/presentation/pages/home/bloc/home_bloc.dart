import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tasks_app/presentation/pages/home/bloc/bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(SelectedTasksHome()) {
    on<TasksHomeSelected>((event, emit) => emit(SelectedTasksHome()));
    on<NotesHomeSelected>((event, emit) => emit(SelectedNotesHome()));
  }
}
