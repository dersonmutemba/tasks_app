import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tasks_app/core/data/database.dart';
import 'package:tasks_app/data/models/note_model.dart';

void main() {
  late Database database;
  late LocalDatabase localDatabase;
  const String noteTable = 'note';
  final NoteModel testNote = NoteModel(
      id: '110ec58a-a0f2-4ac4-8393-c866d813b8d1',
      title: 'title',
      content: 'content',
      createdAt: DateTime.parse('2023-02-22T19:29:39.242'),
      lastEdited: DateTime.parse('2023-02-22T19:29:39.242'));
  final List<Map<String, dynamic>> testNoteList = [
    NoteModel(
            id: '110ec58a-a0f2-4ac4-8393-c866d813b8d1',
            title: 'title',
            content: 'content',
            createdAt: DateTime.parse('2023-02-22T19:29:39.242'),
            lastEdited: DateTime.parse('2023-02-22T19:29:39.242'))
        .toJson(),
    NoteModel(
            id: '310ec58c-a0f2-4ac4-8393-c866d813b8d1',
            title: 'title',
            content: 'content',
            createdAt: DateTime.parse('2023-02-22T19:29:39.242'),
            lastEdited: DateTime.parse('2023-02-22T19:29:39.242'))
        .toJson(),
    NoteModel(
            id: '160ec58a-a0f2-4ac4-8393-c866d813b8d1',
            title: 'title',
            content: 'content',
            createdAt: DateTime.parse('2023-02-22T19:29:39.242'),
            lastEdited: DateTime.parse('2023-02-22T19:29:39.242'))
        .toJson(),
  ];

  setUpAll(() async {
    sqfliteFfiInit();
    database = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    var keys = testNote.toJson().keys;
    await database.execute('''
      CREATE TABLE $noteTable(
        ${keys.elementAt(0)} TEXT PRIMARY KEY,
        ${keys.elementAt(1)} TEXT NOT NULL,
        ${keys.elementAt(2)} TEXT NOT NULL,
        ${keys.elementAt(3)} DATETIME NOT NULL,
        ${keys.elementAt(4)} DATETIME NOT NULL
      );''');
    localDatabase = LocalDatabase(noteTable, database: database);
  });

  group('Test CRUD', () {
    test('Insert Note in the database', () async {
      await localDatabase.insert(noteTable, [testNote.toJson()]);
      const List<String> selectionColumns = ['id'];
      const List<String> otherColumns = [
        'title',
        'content',
        'createdAt',
        'lastEdited'
      ];
      var actual = await localDatabase.getObjects(
          noteTable, selectionColumns, [testNote.id], otherColumns);
      expect(actual, isNotNull);
      expect(NoteModel.fromJson(actual!.first), testNote);
    });

    test('Insert various Notes in the database', () async {
      await localDatabase.insert(noteTable, testNoteList);
      const List<String> selectionColumns = ['id'];
      const List<String> otherColumns = [
        'title',
        'content',
        'createdAt',
        'lastEdited'
      ];
      var actual = await localDatabase.getObjects(
          noteTable, selectionColumns, [testNoteList.last['id']], otherColumns);
      var matcher = NoteModel.fromJson(testNoteList.last);
      expect(actual, isNotNull);
      expect(NoteModel.fromJson(actual!.first), matcher);
    });
  });
}
