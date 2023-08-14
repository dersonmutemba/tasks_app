import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tasks_app/core/error/failure.dart';
import 'package:tasks_app/core/success/success.dart';
import 'package:tasks_app/domain/entities/task_exp.dart';
import 'package:tasks_app/interfaces/dartz.dart';

import 'test_contract_mock.mocks.dart';

void main() {
  late MockTaskContract mockTaskContract;
  late UpdateTask usecase;

  setUp(() {
    mockTaskContract = MockTaskContract();
    usecase = UpdateTask(mockTaskContract);
  });

  final testTask = Task(
    id: "110ec58a-a0f2-4ac4-8393-c866d813b8d1",
    name: "updated name",
    createdAt: DateTime.parse("2023-08-14TT02:55:39:242"),
    status: Status.doing,
  );

  test('Should update Task', () async {
    when(mockTaskContract.updateTask(any))
        .thenAnswer((realInvocation) async => Right(UpdateSuccess()));

    final matcher = await usecase(Params(task: testTask));

    expect(Right(UpdateSuccess()), matcher);
    verify(mockTaskContract.updateTask(testTask));
    verifyNoMoreInteractions(mockTaskContract);
  });

  test('Should not update with empty task', () async {
    final updateEmptyTask = Task(
      id: "110ec58a-a0f2-4ac4-8393-c866d813b8d1",
      name: "",
      createdAt: DateTime.parse("2023-08-14TT02:55:39:242"),
      status: Status.doing,
    );

    when(mockTaskContract.updateTask(any))
        .thenAnswer((realInvocation) async => Left(EmptyTaskFailure()));

    final matcher = await usecase(Params(task: updateEmptyTask));
    
    expect(Left(EmptyTaskFailure()), matcher);
    verify(mockTaskContract.updateTask(updateEmptyTask));
    verifyNoMoreInteractions(mockTaskContract);
  });
}
