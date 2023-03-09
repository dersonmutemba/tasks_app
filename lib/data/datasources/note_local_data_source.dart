import 'package:tasks_app/core/data/database.dart';
import 'package:tasks_app/core/error/exception.dart';

import '../models/note_model.dart';
import 'datasources_constants.dart';

abstract class NoteLocalDataSource {
  Future<NoteModel> getNote(String id);

  Future<List<NoteModel>> getNotes();

  Future<void> cacheNotes(List<NoteModel> notes);

  Future<void> insertNote(NoteModel note);
}

class NoteLocalDataSourceImplementation implements NoteLocalDataSource {
  LocalDatabase localDatabase;
  final String table = datasourcesConstants['noteTable'];
  final List<String> columns = datasourcesConstants['noteColumns'];
  NoteLocalDataSourceImplementation(this.localDatabase);

  @override
  Future<void> cacheNotes(List<NoteModel> notes) async {
    List<Map<String, dynamic>> valuesList = [];
    for (var note in notes) {
      valuesList.add(note.toJson());
    }
    await localDatabase.insert(table, valuesList);
  }
  
  @override
  Future<NoteModel> getNote(String id) async {
    var result = await localDatabase.getObjects(table, [columns.first], [id], columns.sublist(1));
    if(result != null) {
      return NoteModel.fromJson(result.first);
    }
    throw CacheException();
  }
  
  @override
  Future<List<NoteModel>> getNotes() async {
    var results = await localDatabase.getAllObjects(table);
    if(results != null) {
      List<NoteModel> notes = [];
      for(var result in results) {
        notes.add(NoteModel.fromJson(result));
      }
      return notes;
    }
    throw CacheException();
  }
  
  @override
  Future<void> insertNote(NoteModel note) async {
    // TODO: implement insertNote
    throw UnimplementedError();
  }
}