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
  final List<Map<String, dynamic>> testNoteList = List.generate(10, (index) => testNote.toJson());
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
      when(mockLocalDatabase.update(any, any, any, any)).thenAnswer((realInvocation) async => 1);
      when(mockLocalDatabase.delete(any, any, any)).thenAnswer((realInvocation) async => 1);
      when(mockLocalDatabase.getObjects(any, any, any, any)).thenAnswer((realInvocation) async => testNoteList);
  });

  group('Test Sqflite Database', () {
    test('Get Database version', () async {
      expect(await database.getVersion(), dbVersion);
    });

    test('Add Note do database', () async {
      await database.insert(noteTable, testNote.toJson());
      var actual = (await database.query(noteTable)).length;
      expect(actual, 1);
    });
  });
}
