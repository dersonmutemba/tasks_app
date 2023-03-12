class HomeEvent {
  final String title;
  const HomeEvent({required this.title});

  @override
  bool operator ==(Object other) =>
      other is HomeEvent &&
      other.runtimeType == runtimeType &&
      other.title == title;

  @override
  int get hashCode => title.hashCode;
}

class TasksHomeSelected extends HomeEvent {
  const TasksHomeSelected() : super(title: 'Tasks');
}

class NotesHomeSelected extends HomeEvent {
  const NotesHomeSelected() : super(title: 'Notes');
}
