import 'package:uuid/uuid.dart';

import '../../domain/entities/note.dart';

class NoteModel extends Note {
  NoteModel({required Uuid id, required String title, required String content, required DateTime createdAt, required DateTime lastEdited}) : super(id)
}