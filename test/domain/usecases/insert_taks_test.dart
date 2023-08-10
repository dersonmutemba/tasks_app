import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tasks_app/core/success/success.dart';
import 'package:tasks_app/domain/entities/task.dart' as task;

import 'test_contract_mock.mocks.dart';

void main() {
  late MockTaskContract mockTaskContract;
  late InsertTask usecase;

  setUp(() {
    mockTaskContract = MockTaskContract();
    usecase = InsertTask(mockTaskContract);
  });

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
  final testSuccess = RemoteInsertionSuccess(id: testTask.id);

  test('Should insert task', () async {
    when(mockTaskContract.insertTask(any))
        .thenAnswer((realInvocation) async => Right(testSuccess));

    final matcher = await usecase(Params(task: testTask));

    expect(Right(testSuccess), matcher);
    verify(mockTaskContract.insertTask(testTask));
    verifyNoMoreInteractions(mockTaskContract);
  });

  test('Should not insert empty task', () async {
    final emptyTask = task.Task(
      id: 'id',
      name: '',
      description: '',
      icon: 'icon',
      createdAt: DateTime.now(),
      lastEdited: DateTime.now(),
      startedAt: DateTime.now(),
      dueDate: DateTime.now(),
      completed: true,
    );

    when(mockTaskContract.insertTask(emptyTask))
        .thenAnswer((realInvocation) async => Left(EmptyTaskFailure()));

    final matcher = await usecase(Params(task: emptyTask));

    expect(Left(EmptyTaskFailure()), matcher);
    verify(mockTaskContract.insertNote(emptyNote));
    verifyNoMoreInteractions(mockTaskContract);
  });
}
