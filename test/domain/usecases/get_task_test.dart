import 'package:tasks_app/interfaces/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tasks_app/domain/entities/task_exp.dart';
import 'package:tasks_app/domain/usecases/get_task.dart';

import 'test_contract_mock.mocks.dart';

void main() {
  late MockTaskContract mockTaskContract;
  late GetTask usecase;

  setUp(() {
    mockTaskContract = MockTaskContract();
    usecase = GetTask(mockTaskContract);
  });

  const testId = "id";
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

  test('Should get Task from repository', () async {
    when(mockTaskContract.getTask(any))
        .thenAnswer((value) async => Right(testTask));

    final matcher = await usecase(Params(id: testId));

    expect(Right(testTask), matcher);
    verify(mockTaskContract.getTask(testId));
    verifyNoMoreInteractions(mockTaskContract);
  });
}
