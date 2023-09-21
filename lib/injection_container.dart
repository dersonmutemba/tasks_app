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
import 'data/datasources/task_local_data_source.dart';
import 'data/datasources/task_remote_data_source.dart';
import 'data/repositories/note_repository.dart';
import 'data/repositories/task_repository.dart';
import 'domain/contracts/note_contract.dart';
import 'domain/contracts/task_contract.dart';
import 'domain/usecases/delete_note.dart';
import 'domain/usecases/delete_task.dart';
import 'domain/usecases/get_note.dart';
import 'domain/usecases/get_notes.dart';
import 'domain/usecases/get_task.dart';
import 'domain/usecases/get_tasks.dart';
import 'domain/usecases/insert_note.dart';
import 'domain/usecases/insert_task.dart';
import 'domain/usecases/search_notes.dart';
import 'domain/usecases/search_tasks.dart';
import 'domain/usecases/update_note.dart';
import 'domain/usecases/update_task.dart';
import 'presentation/pages/note_page/bloc/note_page_bloc.dart';
import 'presentation/widgets/notes_container/note_list/bloc/note_list_bloc.dart';
import 'presentation/widgets/tasks_container/task_list/bloc/task_list_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();

  serviceLocator.registerFactory(
    () => NotePageBloc(
      deleteNote: serviceLocator(),
      insertNote: serviceLocator(),
      updateNote: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
    () => NoteListBloc(getNotes: serviceLocator(), searchNotes: serviceLocator())
  );

  serviceLocator.registerFactory(
    () => TaskListBloc(getTasks: serviceLocator(), searchTasks: serviceLocator())
  );

  serviceLocator.registerLazySingleton(() => DeleteNote(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetNote(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetNotes(serviceLocator()));
  serviceLocator.registerLazySingleton(() => InsertNote(serviceLocator()));
  serviceLocator.registerLazySingleton(() => UpdateNote(serviceLocator()));
  serviceLocator.registerLazySingleton(() => SearchNotes(serviceLocator()));

  serviceLocator.registerLazySingleton(() => DeleteTask(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetTask(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetTasks(serviceLocator()));
  serviceLocator.registerLazySingleton(() => InsertTask(serviceLocator()));
  serviceLocator.registerLazySingleton(() => UpdateTask(serviceLocator()));
  serviceLocator.registerLazySingleton(() => SearchTasks(serviceLocator()));

  serviceLocator.registerLazySingleton<NoteContract>(
    () => NoteRepository(
      remoteDataSource: serviceLocator(),
      localDataSource: serviceLocator(),
      networkInfo: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton<TaskContract>(
    () => TaskRepository(
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

  serviceLocator.registerSingleton<LocalDatabase>(
      LocalDatabase(datasourcesConstants['tablesQuery']));

  serviceLocator.registerLazySingleton<TaskRemoteDataSource>(
    () => TaskRemoteDataSourceImplementation(),
  );

  serviceLocator.registerLazySingleton<NoteLocalDataSource>(
    () => NoteLocalDataSourceImplementation(
      serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton<TaskLocalDataSource>(
    () => TaskLocalDataSourceImplementation(
      serviceLocator(),
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
