import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';

import 'note_remote_data_source_test.mocks.dart';

@GenerateNiceMocks([MockSpec<http.Client>()])
void main() {
  late NoteRemoteDataSourceImplementation noteRemoteDataSource;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    noteRemoteDataSource =
        NoteRemoteDataSourceImplementation(client: mockClient);
  });
}
