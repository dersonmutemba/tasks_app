import 'package:http/http.dart' as http;
import 'package:tasks_app/domain/entities/note.dart';

import '../models/note_model.dart';

abstract class NoteRemoteDataSource {
  Future<List<NoteModel>> getNotes();

  Future<void> insertNote(Note note);
}

class NoteRemoteDataSourceImplementation implements NoteRemoteDataSource {
  final http.Client client;
  NoteRemoteDataSourceImplementation({required this.client});

  @override
  Future<List<NoteModel>> getNotes() {
    // TODO: implement getNotes
    throw UnimplementedError();
  }
  
  @override
  Future<String> insertNote(Note note) async {
    // TODO: implement insertNote
    throw UnimplementedError();
  }
}
