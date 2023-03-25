class HomeEvent {
  const HomeEvent();

  @override
  bool operator ==(Object other) =>
      other is HomeEvent && other.runtimeType == runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}

class TasksHomeSelected extends HomeEvent {}

class NotesHomeSelected extends HomeEvent {}
