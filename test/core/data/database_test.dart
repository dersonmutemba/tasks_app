import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tasks_app/core/data/constants.dart';
import 'package:tasks_app/core/data/database.dart';
import 'package:tasks_app/data/models/note_model.dart';

import 'database_test.mocks.dart';

@GenerateMocks([LocalDatabase])
void main() {
  late Database database;
  late MockLocalDatabase mockLocalDatabase;
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
    mockLocalDatabase = MockLocalDatabase();
    mockLocalDatabase.db = database;
    when(mockLocalDatabase.update(any, any, any, any))
        .thenAnswer((realInvocation) async => 1);
    when(mockLocalDatabase.delete(any, any, any))
        .thenAnswer((realInvocation) async => 1);
    when(mockLocalDatabase.getObjects(any, any, any, any))
        .thenAnswer((realInvocation) async => testNoteList);
  });

  group('Test Sqflite Database', () {
    test('Insert Note to database', () async {
      await database.insert(noteTable, testNote.toJson());
      var actual = (await database.query(noteTable)).length;
      expect(actual, 1);
    });

    test('Update Note in the database', () async {
      const String matcher = 'another content';
      final NoteModel noteModel = NoteModel(
          id: testNote.id,
          title: 'title',
          content: matcher,
          createdAt: testNote.createdAt,
          lastEdited: testNote.lastEdited);
      var keys = testNote.toJson().keys;
      await database.update(noteTable, noteModel.toJson(),
          where: '${keys.first} = ?', whereArgs: [noteModel.id]);
      var actual = (await database.query(noteTable)).first['content'];
      expect(actual, matcher);
    });

    test('Delete Note in the database', () async {
      var keys = testNote.toJson().keys;
      await database.delete(noteTable,
          where: '${keys.first} = ?', whereArgs: [testNote.id]);
      var actual = (await database.query(noteTable)).length;
      expect(actual, 0);
    });

    test('Insert multiple Notes in the database', () async {
      Batch batch = database.batch();
      for (var map in testNoteList) {
        batch.insert(noteTable, map,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit();
      var actual = (await database.query(noteTable)).length;
      expect(actual, testNoteList.length);
    });
  });
}
