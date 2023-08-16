import 'package:tasks_app/interfaces/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tasks_app/core/error/failure.dart';
import 'package:tasks_app/core/success/success.dart';
import 'package:tasks_app/domain/entities/task_exp.dart';
import 'package:tasks_app/domain/usecases/insert_task.dart';

import 'test_contract_mock.mocks.dart';

void main() {
  late MockTaskContract mockTaskContract;
  late InsertTask usecase;

  setUp(() {
    mockTaskContract = MockTaskContract();
    usecase = InsertTask(mockTaskContract);
  });

  final testTask = Task(
    id: 'id',
    name: 'name',
    description: 'description',
    icon: 'icon',
    createdAt: DateTime.now(),
    lastEdited: DateTime.now(),
    startedAt: DateTime.now(),
    dueDate: DateTime.now(),
    status: Status.completed,
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
    final emptyTask = Task(
      id: 'id',
      name: '',
      description: 'description',
      icon: 'icon',
      createdAt: DateTime.now(),
      lastEdited: DateTime.now(),
      startedAt: DateTime.now(),
      dueDate: DateTime.now(),
      status: Status.completed,
    );

    when(mockTaskContract.insertTask(emptyTask))
        .thenAnswer((realInvocation) async => Left(EmptyTaskFailure()));

    final matcher = await usecase(Params(task: emptyTask));

    expect(Left(EmptyTaskFailure()), matcher);
    verify(mockTaskContract.insertTask(emptyTask));
    verifyNoMoreInteractions(mockTaskContract);
  });
}
