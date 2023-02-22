import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tasks_app/data/models/note_model.dart';
import 'package:tasks_app/domain/entities/note.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  final testNoteModel = NoteModel(
      id: "110ec58a-a0f2-4ac4-8393-c866d813b8d1",
      title: "title",
      content: "content",
      createdAt: DateTime.parse("2023-02-22T19:29:39.242"),
      lastEdited: DateTime.parse("2023-02-22T19:29:39.242"));

  test('Should be a subclass of Note entity', () async {
    expect(testNoteModel, isA<Note>());
  });

  group('from JSON', () {
    test('returns a valid model from JSON', () async {
      final Map<String, dynamic> jsonMap = jsonDecode(fixture('note.json'));

      final actual = NoteModel.fromJson(jsonMap);

      expect(actual, testNoteModel);
    });
  });

  group('to JSON', () {
    test('returns a valid JSON map', () async {
      final actual = testNoteModel.toJson();

      final matcher = {
        "id": "110ec58a-a0f2-4ac4-8393-c866d813b8d1",
        "title": "title",
        "content": "content",
        "createdAt": "2023-02-22T19:29:39.242",
        "lastEdited": "2023-02-22T19:29:39.242"
      };

      expect(actual, matcher);
    });
  });
}
