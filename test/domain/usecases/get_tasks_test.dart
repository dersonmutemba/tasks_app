import 'package:tasks_app/interfaces/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tasks_app/core/usecases/usecase.dart';
import 'package:tasks_app/domain/entities/task_exp.dart';
import 'package:tasks_app/domain/usecases/get_tasks.dart';

import 'test_contract_mock.mocks.dart';

void main() {
  late MockTaskContract mockTaskContract;
  late GetTasks usecase;

  setUp(() {
    mockTaskContract = MockTaskContract();
    usecase = GetTasks(mockTaskContract);
  });

  final testTasks = [
    Task(
      id: 'id',
      name: 'name',
      description: 'description',
      icon: 'icon',
      createdAt: DateTime.now(),
      lastEdited: DateTime.now(),
      startedAt: DateTime.now(),
      dueDate: DateTime.now(),
      status: Status.completed,
    )
  ];

  test('Shoud get Tasks from the repository', () async {
    when(mockTaskContract.getTasks())
        .thenAnswer((value) async => Right(testTasks));

    final matcher = await usecase(NoParams());

    expect(Right(testTasks), matcher);
    verify(mockTaskContract.getTasks());
    verifyNoMoreInteractions(mockTaskContract);
  });
}
