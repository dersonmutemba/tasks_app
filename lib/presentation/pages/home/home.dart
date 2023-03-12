import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/bloc.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(),
      child: Scaffold(
        body: Center(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: ((context, state) {
              return TextButton(
                onPressed: () {
                  if (state is SelectedTasksHome) {
                    context.read<HomeBloc>().add(NotesHomeSelected());
                  } else if (state is SelectedNotesHome) {
                    context.read<HomeBloc>().add(TasksHomeSelected());
                  }
                },
                child: Text(state.title),
              );
            }),
          ),
        ),
      ),
    );
  }
}
