import 'package:uuid/uuid.dart';

class Note {
  final Uuid id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime lastEdited;
  Note(
      {required this.id,
      required this.title,
      required this.content,
      required this.createdAt,
      required this.lastEdited});

  @override
  bool operator ==(Object other) =>
      other is Note &&
      other.runtimeType == runtimeType &&
      other.id == id &&
      other.title == title &&
      other.content == content &&
      other.createdAt == createdAt &&
      other.lastEdited == lastEdited;

  @override
  int get hashCode => ("$id$title$content$createdAt$lastEdited").hashCode;
}
