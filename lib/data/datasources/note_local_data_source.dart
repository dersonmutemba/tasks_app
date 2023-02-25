import 'package:tasks_app/core/data/database.dart';

import '../models/note_model.dart';

abstract class NoteLocalDataSource {
  Future<NoteModel> getNote(String id);

  Future<List<NoteModel>> getNotes();

  Future<void> cacheNotes(List<NoteModel> notes);
}

class NoteLocalDataSourceImplementation implements NoteLocalDataSource {
  LocalDatabase localDatabase;
  final String table;
  NoteLocalDataSourceImplementation(this.localDatabase, {required this.table});

  @override
  Future<void> cacheNotes(List<NoteModel> notes) async {
    List<Map<String, dynamic>> valuesList = [];
    for (var note in notes) {
      valuesList.add(note.toJson());
    }
    await localDatabase.insert(table, valuesList);
  }
  
  @override
  Future<NoteModel> getNote(String id) {
    // TODO: implement getNote
    throw UnimplementedError();
  }
  
  @override
  Future<List<NoteModel>> getNotes() {
    // TODO: implement getNotes
    throw UnimplementedError();
  }
}