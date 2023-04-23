import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'note_contract_mock.mocks.dart';

void main() {
  late MockNoteContract mockNoteContract;
  late DeleteNote usecase;

  setUp(() {
    mockNoteContract = MockNoteContract();
    usecase = DeleteNote(mockNoteContract);
  });

  test('Shoud delete Note', () async {
    when(mockNoteContract.deleteNote(any))
        .thenAnswer((realInvocation) async => Right(DeleteSuccess()));

    const noteId = "110ec58a-a0f2-4ac4-8393-c866d813b8d1";
    final matcher = await usecase(Params(id: noteId));

    expect(Right(DeleteSuccess()), matcher);
    verify(mockNoteContract.deleteNote(noteId));
    verifyNoMoreInteractions(mockNoteContract);
  });

  test('Should not delete when wrong ID is given', () async {
    when(mockNoteContract.deleteNote(any))
        .thenAnswer((realInvocation) async => Left(DeleteFailure));

    const invalidId = '';
    final matcher = await usecase(Params(id: invalidId));

    expect(Left(DeleteFailure()), matcher);
    verify(mockNoteContract.deleteNote(invalidId));
    verifyNoMoreInteractions(mockNoteContract);
  });
}
