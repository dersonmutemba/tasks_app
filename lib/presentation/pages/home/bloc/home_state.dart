class HomeState {
  const HomeState();

  @override
  bool operator ==(Object other) =>
      other is HomeState && other.runtimeType == runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}

class SelectedTasksHome extends HomeState {}

class SelectedNotesHome extends HomeState {}
