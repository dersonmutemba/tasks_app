import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../../../pages/note_page/note_page.dart';
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
                return Dismissible(
                  key: ValueKey(state.notes[index]),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.endToStart) {
                      return await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Do you want to delete?'),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, true);
                                },
                                child: const Text('Yes'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                                child: const Text('No'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                    return false;
                  },
                  child: NoteView(
                    note: state.notes[index],
                    openNote: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              NotePage(context, note: state.notes[index]),
                        ),
                      ).then(
                          (value) => context.read<NoteListBloc>().add(Load()));
                    },
                  ),
                );
              },
            );
          }
          return Container();
        }),
      ),
    );
  }
}
