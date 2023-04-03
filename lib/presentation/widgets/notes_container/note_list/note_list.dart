import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../note_view.dart';
import 'bloc/bloc.dart';

class NoteList extends StatelessWidget {
  const NoteList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (arg) => serviceLocator<NoteListBloc>()..add(Load()),
      child: BlocBuilder<NoteListBloc, NoteListState>(
        builder: ((context, state) {
          if (state is Empty) {
            return const Text('Empty');
          } else if (state is Error) {
            return const Text('Error');
          } else if (state is Loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is Loaded) {
            return ListView.builder(
              itemCount: state.notes.length,
              itemBuilder: (context, index) {
                return NoteView(note: state.notes[index]);
              },
            );
          }
          return Container();
        }),
      ),
    );
  }
}
