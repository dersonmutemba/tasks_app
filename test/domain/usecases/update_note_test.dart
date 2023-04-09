import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tasks_app/core/error/failure.dart';
import 'package:tasks_app/core/success/success.dart';
import 'package:tasks_app/domain/entities/note.dart';

import 'note_contract_mock.mocks.dart';

void main() {
  late MockNoteContract mockNoteContract;
  late UpdateNote usecase;

  setUp(() {
    mockNoteContract = MockNoteContract();
    usecase = UpdateNote(mockNoteContract);
  });

  final testNote = Note(
    id: "110ec58a-a0f2-4ac4-8393-c866d813b8d1",
    title: "updated title",
    content: "updated content",
    createdAt: DateTime.parse("2023-02-22T19:29:39.242"),
    lastEdited: DateTime.parse("2023-02-22T19:29:40.242"),
  );

  test('Should update Note', () async {
    when(mockNoteContract.updateNote(any))
        .thenAnswer((realInvocation) async => Right(UpdateSuccess()));

    final matcher = await usecase(Params(note: testNote));

    expect(Right(UpdateSuccess()), matcher);
    verify(mockNoteContract.updateNote(testNote));
    verifyNoMoreInteractions(mockNoteContract);
  });

  test('Should not update with empty note', () async {
    final updateEmptyNote = Note(
      id: "110ec58a-a0f2-4ac4-8393-c866d813b8d1",
      title: "",
      content: "",
      createdAt: DateTime.parse("2023-02-22T19:29:39.242"),
      lastEdited: DateTime.parse("2023-02-22T19:29:40.242"),
    );

    when(mockNoteContract.updateNote(any))
        .thenAnswer((realInvocation) async => Left(EmptyNoteFailure()));

    final matcher = await usecase(Params(note: updateEmptyNote));

    expect(Left(EmptyNoteFailure()), matcher);
    verify(mockNoteContract.updateNote(updateEmptyNote));
    verifyNoMoreInteractions(mockNoteContract);
  });
}
