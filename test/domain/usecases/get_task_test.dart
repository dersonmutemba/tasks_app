import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tasks_app/domain/entities/task.dart' as task;

import 'test_contract_mock.mocks.dart';

void main() {
  late MockTaskContract mockTaskContract;
  late GetTask usecase;

  setUp(() {
    mockTaskContract = MockTaskContract();
    usecase = GetTask(mockTaskContract);
  });

  const testId = "id";
  final testTask = task.Task(
    id: 'id',
    name: 'name',
    description: 'description',
    icon: 'icon',
    createdAt: DateTime.now(),
    lastEdited: DateTime.now(),
    startedAt: DateTime.now(),
    dueDate: DateTime.now(),
    completed: true,
  );

  test('Should get Task from repository', () async {
    when(mockTaskContract.getTask(any))
        .thenAnswer((value) async => Right(testTask));

    final matcher = await usecase(Params(id: testId));

    expect(Right(testTask), matcher);
    verify(mockTaskContract.getTask(testId));
    verifyNoMoreInteractions(mockTaskContract);
  });
}
