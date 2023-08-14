import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tasks_app/core/success/success.dart';
import 'package:tasks_app/domain/usecases/delete_task.dart';
import 'package:tasks_app/interfaces/dartz.dart';

import 'test_contract_mock.mocks.dart';

void main() {
  late MockTaskContract mockTaskContract;
  late DeleteTask usecase;

  setUp(() {
    mockTaskContract = MockTaskContract();
    usecase = DeleteTask(mockTaskContract);
  });

  test('Should delete Task', () async {
    when(mockTaskContract.deleteTask(any)).thenAnswer((realInvocation) async => Right(DeleteSuccess()));

    const taskId = "110ec58a-a0f2-4ac4-8393-c866d813b8d1";
    final matcher  = await usecase(Params(id: taskId));

    expect(Right(DeleteSuccess()), matcher);
    verify(mockTaskContract.deleteTask(taskId));
    verifyNoMoreInteractions(mockTaskContract);
  });
}