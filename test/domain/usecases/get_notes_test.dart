import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tasks_app/core/usecases/usecase.dart';
import 'package:tasks_app/domain/entities/note.dart';
import 'package:tasks_app/domain/usecases/get_notes.dart';

import 'note_contract_mock.mocks.dart';

void main() {
  late MockNoteContract mockNoteContract;
  late GetNotes usecase;

  setUp(() {
    mockNoteContract = MockNoteContract();
    usecase = GetNotes(mockNoteContract);
  });

  final testNotes = [Note(id: "id", title: "title", content: "content", createdAt: DateTime.now(), lastEdited: DateTime.now())];

  test('Should get Notes from the repository', () async {
    when(mockNoteContract.getNotes()).thenAnswer((value) async => Right(testNotes));

    final matcher = await usecase(NoParams());

    expect(Right(testNotes), matcher);
    verify(mockNoteContract.getNotes());
    verifyNoMoreInteractions(mockNoteContract);
  });
}