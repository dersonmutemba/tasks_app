import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/data/database.dart';
import 'core/network/data_connection_checker.dart';
import 'core/network/network_info.dart';
import 'data/datasources/datasources_constants.dart';
import 'data/datasources/note_local_data_source.dart';
import 'data/datasources/note_remote_data_source.dart';
import 'data/repositories/note_repository.dart';
import 'domain/contracts/note_contract.dart';
import 'domain/usecases/get_note.dart';
import 'domain/usecases/get_notes.dart';
import 'presentation/pages/note_page/bloc/note_page_bloc.dart';
import 'presentation/widgets/notes_container/note_list/bloc/note_list_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();

  serviceLocator.registerFactory(
    () => NotePageBloc(
      noteRepository: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => NoteListBloc(getNotes: serviceLocator()),
  );

  serviceLocator.registerLazySingleton(() => GetNote(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetNotes(serviceLocator()));

  serviceLocator.registerLazySingleton<NoteContract>(
    () => NoteRepository(
      remoteDataSource: serviceLocator(),
      localDataSource: serviceLocator(),
      networkInfo: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton<NoteRemoteDataSource>(
    () => NoteRemoteDataSourceImplementation(
      client: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton<NoteLocalDataSource>(
    () => NoteLocalDataSourceImplementation(
      LocalDatabase(datasourcesConstants['noteTableQuery']),
    ),
  );

  serviceLocator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImplementation(
      serviceLocator(),
    ),
  );

  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPreferences);

  serviceLocator.registerLazySingleton(() => http.Client());

  serviceLocator.registerLazySingleton(() => DataConnectionChecker());
}
