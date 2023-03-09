import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tasks_app/core/success/success.dart';
import 'package:tasks_app/domain/contracts/note_contract.dart';
import 'package:tasks_app/domain/entities/note.dart';
import 'package:tasks_app/domain/usecases/insert_note.dart';

import 'get_note_test.mocks.dart';

@GenerateNiceMocks([MockSpec<NoteContract>()])
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
  final testSuccess = RemoteInsertionSuccess();

  test('Should insert note', () async {
    when(mockNoteContract.insertNote(any))
        .thenAnswer((realInvocation) async => Right(testSuccess));

    final matcher = await usecase(Params(note: testNote));

    expect(Right(testSuccess), matcher);
    verify(mockNoteContract.insertNote(testNote));
    verifyNoMoreInteractions(mockNoteContract);
  });
}
