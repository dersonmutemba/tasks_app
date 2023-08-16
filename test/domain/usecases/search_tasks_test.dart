import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tasks_app/domain/entities/task_exp.dart';
import 'package:tasks_app/domain/usecases/search_tasks.dart';
import 'package:tasks_app/interfaces/dartz.dart';

import 'test_contract_mock.mocks.dart';

void main() {
  late MockTaskContract mockTaskContract;
  late SearchTasks usecase;

  setUp(() {
    mockTaskContract = MockTaskContract();
    usecase = SearchTasks(mockTaskContract);
  });

  const testSearchQuery = "query";
  final testTasks = [
    Task(
      id: "110ec58a-a0f2-4ac4-8393-c866d813b8d1",
      name: "updated name",
      createdAt: DateTime.parse("2023-08-15T22:58:39.242"),
      status: Status.doing,
    )
  ];

  test('Should search Tasks in the repository', () async {
    when(mockTaskContract.searchTasks(any))
        .thenAnswer((value) async => Right(testTasks));

    final matcher = await usecase(Params(query: testSearchQuery));

    expect(Right(testTasks), matcher);
  });
}
