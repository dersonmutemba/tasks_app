import 'enumuration/status.dart';

class Task {
  final String id;
  final String name;
  final String? description;
  final String? icon;
  final DateTime createdAt;
  final DateTime? lastEdited;
  final DateTime? startedAt;
  final DateTime? dueDate;
  final Status status;
  // TODO: Add repetition properties
  Task(
      {required this.id,
      required this.name,
      this.description,
      this.icon,
      required this.createdAt,
      this.lastEdited,
      this.startedAt,
      this.dueDate,
      required this.status});

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
      other.status == status;

  @override
  int get hashCode =>
      ("$id$name$description$icon$createdAt$lastEdited$startedAt$dueDate$status")
          .hashCode;
}
