import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tasks_app/core/platform/network_info.dart';
import 'package:tasks_app/data/datasources/note_local_data_source.dart';
import 'package:tasks_app/data/datasources/note_remote_data_source.dart';

@GenerateNiceMocks([MockSpec<NetworkInfo>()])
@GenerateNiceMocks([MockSpec<NoteLocalDataSource>()])
@GenerateNiceMocks([MockSpec<NoteRemoteDataSource>()])

void main() {

}