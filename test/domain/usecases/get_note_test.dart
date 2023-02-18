import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tasks_app/domain/contracts/note_contract.dart';
import 'package:tasks_app/domain/entities/note.dart';
import 'package:tasks_app/domain/usecases/get_note.dart';
import 'package:uuid/uuid.dart';

import 'get_note_test.mocks.dart';

@GenerateMocks([NoteContract])
void main() {
  MockNoteContract mockNoteContract = MockNoteContract();
  GetNote usecase = GetNote(mockNoteContract);

  setUp(() {
    mockNoteContract = MockNoteContract();
    usecase = GetNote(mockNoteContract);
  });

  const testId = Uuid();
  final testNote = Note(id: testId, title: "title", content: "content", createdAt: DateTime.now(), lastEdited: DateTime.now());

  test('Should get Note from the repository', () async {
    when(mockNoteContract.getNote(any).then((value) async => Right(testNote)));

    final matcher = await usecase.execute(id: testId);

    expect(Right(testNote), matcher);
    verify(mockNoteContract.getNote(testId));
    verifyNoMoreInteractions(mockNoteContract);
  });
}