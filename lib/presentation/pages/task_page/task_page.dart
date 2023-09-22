import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/task.dart';
import '../../../injection_container.dart';
import 'bloc/bloc.dart';

class TaskPage extends StatelessWidget {
  final Task? task;
  final BuildContext ancestorContext;
  const TaskPage(this.ancestorContext, {Key? key, this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var taskBloc = serviceLocator<TaskPageBloc>();

    return Scaffold(
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            // TODO: Add logic for pop
            return true;
          },
          child: BlocProvider(
            create: (context) => taskBloc..add(Load(task: task)),
            child: BlocBuilder<TaskPageBloc, TaskPageState>(
              builder: (context, state) {
                if (state is Creating || state is Editing) {
                  return const Center(
                    child: Text('Creating or Editing'),
                  );
                } else if (state is Loading || state is Saving) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is Error) {
                  return Container(
                    color: Colors.red,
                    child: Center(
                      child: Text('Error: ${state.message}'),
                    ),
                  );
                } else if (state is Saved) {
                  return Center(
                    child: Text(state.message),
                  );
                }
                return const Center(
                  child: Text('Unknown error'),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
