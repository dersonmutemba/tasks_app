import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../injection_container.dart';
import '../bloc/bloc.dart';

class NotesPage extends StatelessWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (arg) => serviceLocator<NoteBloc>(),
      child: BlocBuilder<NoteBloc, NoteState>(
        builder: ((context, state) {
          if (state is Empty) {
            return const Text('Empty');
          } else if (state is Error) {
            return const Text('Error');
          } else if (state is Loading) {
            return const CircularProgressIndicator();
          } else if (state is Loaded) {
            return const Text('Loaded Notes');
          }
          return Container();
        }),
      ),
    );
  }
}
