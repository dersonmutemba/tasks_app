import 'package:flutter_test/flutter_test.dart';
import 'package:tasks_app/domain/entities/enumuration/status.dart';

void main() {
  test('Should return a Status from a valid String', () {
    const matcher = Status.completed;

    final actual = statusFromString('completed');

    expect(actual, matcher);
  });

  test('Should validate being case insensitive', () {
    const matcher = Status.notStarted;

    final actual = statusFromString('notstarted');

    expect(actual, matcher);
  });

  test('Should return null on invalid status', () {
    final actual = statusFromString('text');

    expect(actual, null);
  });
}