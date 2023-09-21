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

class SelectedNotesHome extends HomeState {
  const SelectedNotesHome() : super(title: 'Notes');
}

class Dismissed extends HomeState {
  const Dismissed() : super(title: '');
}

class Loading extends HomeState {
  const Loading() : super(title: '');
}
