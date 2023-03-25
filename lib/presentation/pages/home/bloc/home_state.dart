class HomeState {
  final String title;
  const HomeState({required this.title});

  @override
  bool operator ==(Object other) =>
      other is HomeState &&
      other.runtimeType == runtimeType &&
      other.title == title;

  @override
  int get hashCode => runtimeType.hashCode;
}

class SelectedTasksHome extends HomeState {
  const SelectedTasksHome() : super(title: 'Tasks');
}

class SelectedNotesHome extends HomeState {
  const SelectedNotesHome() : super(title: 'Notes');
}
