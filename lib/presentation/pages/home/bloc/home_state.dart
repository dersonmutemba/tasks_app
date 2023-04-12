import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final String title;
  const HomeState({required this.title});

  @override
  List<Object> get props => [title];
}

class SelectedTasksHome extends HomeState {
  const SelectedTasksHome() : super(title: 'Tasks');
}

class SelectingTasksHome extends HomeState {
  const SelectingTasksHome() : super(title: 'Tasks');
}

class SelectedNotesHome extends HomeState {
  const SelectedNotesHome() : super(title: 'Notes');
}

class SelectingNotesHome extends HomeState {
  const SelectingNotesHome() : super(title: 'Notes');
}
