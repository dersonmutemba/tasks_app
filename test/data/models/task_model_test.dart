import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tasks_app/data/models/task_model.dart';
import 'package:tasks_app/domain/entities/task_exp.dart';

import '../../fixtures/fixture_reader.dart';

void main() {
  final testTaskModel = TaskModel(
    id: "110ec58a-a0f2-4ac4-8393-c866d813b8d1",
    name: 'name',
    createdAt: DateTime.parse("2023-08-17T23:45:39.242"),
    status: Status.doing,
  );

  test('Should be a subclass of Task', () async {
    expect(testTaskModel, isA<Task>());
  });

  group('from JSON', () {
    test('Should return a valid model from JSON', () async {
      final Map<String, dynamic> jsonMap = jsonDecode(fixture('task.json'));

      final actual = TaskModel.fromJson(jsonMap);

      expect(actual, testTaskModel);
    });
  });

  group('to JSON', () {
    test('Should return a valid JSON map', () async {
      final actual = testTaskModel.toJson();

      final matcher = {
        "id": "110ec58a-a0f2-4ac4-8393-c866d813b8d1",
        "name": "name",
        "description": null,
        "icon": null,
        "createdAt": "2023-08-17T23:45:39.242",
        "lastEdited": null,
        "startedAt": null,
        "dueDate": null,
        "status": 'Status.doing',
      };

      expect(actual, matcher);
    });
  });
}
