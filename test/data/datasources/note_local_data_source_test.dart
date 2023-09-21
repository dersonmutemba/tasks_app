import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tasks_app/core/data/database.dart';
import 'package:tasks_app/core/error/exception.dart';
import 'package:tasks_app/data/datasources/note_local_data_source.dart';
import 'package:tasks_app/data/models/note_model.dart';

void main() {
  late Database database;
  late LocalDatabase localDatabase;
  late NoteLocalDataSourceImplementation noteLocalDataSource;
  const String noteTable = 'note';
  final NoteModel testNote = NoteModel(
      id: '110ec58a-a0f2-4ac4-893-c866d813b8d1',
      title: 'title',
      content: 'content',
      createdAt: DateTime.parse('2023-02-22T19:29:39.242'),
      lastEdited: DateTime.parse('2023-02-22T19:29:39.242'));
  final List<NoteModel> testNoteList = [
    NoteModel(
        id: '110ec58a-a0f2-4ac4-8393-c866d813b8d1',
        title: 'title',
        content: 'content',
        createdAt: DateTime.parse('2023-02-22T19:29:39.242'),
        lastEdited: DateTime.parse('2023-02-22T19:29:39.242')),
    NoteModel(
        id: '310ec58c-a0f2-4ac4-8393-c866d813b8d1',
        title: 'title',
        content: 'content',
        createdAt: DateTime.parse('2023-02-22T19:29:39.242'),
        lastEdited: DateTime.parse('2023-02-22T19:29:39.242')),
    NoteModel(
        id: '160ec58a-a0f2-4ac4-8393-c866d813b8d1',
        title: 'title',
        content: 'content',
        createdAt: DateTime.parse('2023-02-22T19:29:39.242'),
        lastEdited: DateTime.parse('2023-02-22T19:29:39.242')),
  ];
  const String testSearchQuery = 'search';
  final List<NoteModel> testNoteListToSearch = [
    NoteModel(
        id: '110ec58a-a0f2-4ac4-8393-c866d813b8d1',
        title: 'title',
        content: 'content',
        createdAt: DateTime.parse('2023-02-22T19:29:39.242'),
        lastEdited: DateTime.parse('2023-02-22T19:29:39.242')),
    NoteModel(
        id: '310ec58c-a0f2-4ac4-8393-c866d813b8d1',
        title: 'search title',
        content: 'content',
        createdAt: DateTime.parse('2023-02-22T19:29:39.242'),
        lastEdited: DateTime.parse('2023-02-22T19:29:39.242')),
    NoteModel(
        id: '160ec58a-a0f2-4ac4-8393-c866d813b8d1',
        title: 'search',
        content: 'search',
        createdAt: DateTime.parse('2023-02-22T19:29:39.242'),
        lastEdited: DateTime.parse('2023-02-22T19:29:39.242')),
  ];
  final List<NoteModel> testNoteListSearchResult = [
    NoteModel(
        id: '160ec58a-a0f2-4ac4-8393-c866d813b8d1',
        title: 'search',
        content: 'search',
        createdAt: DateTime.parse('2023-02-22T19:29:39.242'),
        lastEdited: DateTime.parse('2023-02-22T19:29:39.242')),
    NoteModel(
        id: '310ec58c-a0f2-4ac4-8393-c866d813b8d1',
        title: 'search title',
        content: 'content',
        createdAt: DateTime.parse('2023-02-22T19:29:39.242'),
        lastEdited: DateTime.parse('2023-02-22T19:29:39.242')),
  ];
  final testNoteModel = NoteModel(
      id: "910ec58a-a0f2-4ac4-8393-c866d813b8d1",
      title: "title",
      content: "content",
      createdAt: DateTime.parse("2023-02-22T19:29:39.242"),
      lastEdited: DateTime.parse("2023-02-22T19:29:39.242"));
  final updatedTestNoteModel = NoteModel(
      id: "910ec58a-a0f2-4ac4-8393-c866d813b8d1",
      title: "upgrade title",
      content: "upgrade content",
      createdAt: DateTime.parse("2023-02-22T19:29:39.242"),
      lastEdited: DateTime.parse("2023-02-22T19:29:39.242"));

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
    localDatabase = LocalDatabase([noteTable], database: database);
    noteLocalDataSource = NoteLocalDataSourceImplementation(localDatabase);
  });

  group('Test Local DataSource Implementation', () {
    test('Cache NoteModel', () async {
      await noteLocalDataSource.cacheNotes(testNoteList);
      var actual = await noteLocalDataSource.getNote(testNoteList.first.id);
      expect(actual, testNoteList.first);
    });

    test('Trying to get unexisting Note', () async {
      var future = noteLocalDataSource.getNote(testNote.id);
      expectLater(future, throwsA(isA<CacheException>()));
    });

    test('Get all Notes', () async {
      var actual = await noteLocalDataSource.getNotes();
      expect(actual, testNoteList);
    });

    test('Single Note insertion should return id', () async {
      var actual = await noteLocalDataSource.insertNote(testNoteModel);
      var matcher = testNoteModel.id;
      expect(actual, matcher);
    });

    test('Upgrade Note', () async {
      var countBefore = (await noteLocalDataSource.getNotes()).length;
      await noteLocalDataSource.updateNote(updatedTestNoteModel);
      var countAfter = (await noteLocalDataSource.getNotes()).length;
      var actualTitle =
          (await noteLocalDataSource.getNote(updatedTestNoteModel.id)).title;
      var matcherTitle = updatedTestNoteModel.title;
      var actualContent =
          (await noteLocalDataSource.getNote(updatedTestNoteModel.id)).content;
      var matcherContent = updatedTestNoteModel.content;
      expect(countBefore, countAfter);
      expect(actualTitle, matcherTitle);
      expect(actualContent, matcherContent);
    });

    test('Delete Note', () async {
      await noteLocalDataSource.deleteNote(testNoteModel.id);
      var future = noteLocalDataSource.getNote(testNoteModel.id);
      expect(future, throwsA(isA<CacheException>()));
    });

    test('Search should return notes containing search in order of matching', () async {
      await noteLocalDataSource.cacheNotes(testNoteListToSearch);
      var actual = await noteLocalDataSource.searchNotes(testSearchQuery);
      expect(actual, testNoteListSearchResult);
    });
  });
}
