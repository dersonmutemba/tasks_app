import 'package:http/http.dart' as http;

import '../models/note_model.dart';

abstract class NoteRemoteDataSource {
  Future<List<NoteModel>> getNotes();
}

class NoteRemoteDataSourceImplementation implements NoteRemoteDataSource {
  final http.Client client;
  NoteRemoteDataSourceImplementation({required this.client});

  @override
  Future<List<NoteModel>> getNotes() {
    // TODO: implement getNotes
    throw UnimplementedError();
  }
}
