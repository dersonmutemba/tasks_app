import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tasks_app/domain/entities/note.dart';

import 'note_contract_mock.mocks.dart';

void main() {
  late MockNoteContract mockNoteContract;
  late SearchNotes usecase;

  setUp(() {
    mockNoteContract = MockNoteContract();
    usecase = SearchNotes(mockNoteContract);
  });

  const testSearchQuery = 'title';
  final testNotes = [
    Note(
        id: "id",
        title: "title",
        content: "content",
        createdAt: DateTime.now(),
        lastEdited: DateTime.now())
  ];

  test('Should search Notes in the repository', () async {
    when(mockNoteContract.searchNotes(any))
        .thenAnswer((value) async => Right(testNotes));

    final matcher = await usecase(Params(query: testSearchQuery));

    expect(Right(testNotes), matcher);
    verify(mockNoteContract.searchNotes(testSearchQuery));
    verifyNoMoreInteractions(mockNoteContract);
  });
}
