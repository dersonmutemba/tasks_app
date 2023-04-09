import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tasks_app/core/error/failure.dart';
import 'package:tasks_app/core/success/success.dart';
import 'package:tasks_app/domain/entities/note.dart';
import 'package:tasks_app/domain/usecases/insert_note.dart';

import 'note_contract_mock.mocks.dart';

void main() {
  late MockNoteContract mockNoteContract;
  late InsertNote usecase;

  setUp(() {
    mockNoteContract = MockNoteContract();
    usecase = InsertNote(mockNoteContract);
  });

  final testNote = Note(
    id: "110ec58a-a0f2-4ac4-8393-c866d813b8d1",
    title: "title",
    content: "content",
    createdAt: DateTime.parse("2023-02-22T19:29:39.242"),
    lastEdited: DateTime.parse("2023-02-22T19:29:39.242"),
  );
  final testSuccess = RemoteInsertionSuccess(id: testNote.id);

  test('Should insert note', () async {
    when(mockNoteContract.insertNote(any))
        .thenAnswer((realInvocation) async => Right(testSuccess));

    final matcher = await usecase(Params(note: testNote));

    expect(Right(testSuccess), matcher);
    verify(mockNoteContract.insertNote(testNote));
    verifyNoMoreInteractions(mockNoteContract);
  });

  test('Should not insert empty note', () async {
    final emptyNote = Note(
      id: "110ec58a-a0f2-4ac4-8393-c866d813b8d6",
      title: "",
      content: "",
      createdAt: DateTime.now(),
      lastEdited: DateTime.now(),
    );

    when(mockNoteContract.insertNote(emptyNote))
        .thenAnswer((realInvocation) async => Left(EmptyNoteFailure()));

    final matcher = await usecase(Params(note: emptyNote));

    expect(Left(EmptyNoteFailure()), matcher);
    verify(mockNoteContract.insertNote(emptyNote));
    verifyNoMoreInteractions(mockNoteContract);
  });
}
