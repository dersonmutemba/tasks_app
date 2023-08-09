class Task {
  final String id;
  final String name;
  final String description;
  final String icon;
  final DateTime createdAt;
  final DateTime lastEdited;
  final DateTime startedAt;
  final DateTime dueDate;
  final bool completed;
  // TODO: Add repetition properties
  Task(
      {required this.id,
      required this.name,
      required this.description,
      required this.icon,
      required this.createdAt,
      required this.lastEdited,
      required this.startedAt,
      required this.dueDate,
      required this.completed});

  @override
  bool operator ==(Object other) =>
      other is Task &&
      other.runtimeType == runtimeType &&
      other.id == id &&
      other.name == name &&
      other.description == description &&
      other.icon == icon &&
      other.createdAt == createdAt &&
      other.lastEdited == lastEdited &&
      other.startedAt == startedAt &&
      other.dueDate == dueDate &&
      other.completed == completed;

  @override
  int get hashCode =>
      ("$id$name$description$icon$createdAt$lastEdited$startedAt$dueDate$completed")
          .hashCode;
}
