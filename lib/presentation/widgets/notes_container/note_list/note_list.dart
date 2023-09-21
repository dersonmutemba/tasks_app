import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/usecases/delete_note.dart';
import '../../../../injection_container.dart';
import '../../../pages/note_page/note_page.dart';
import '../../my_search_bar.dart';
import '../note_view.dart';
import 'bloc/bloc.dart';

class NoteList extends StatelessWidget {
  const NoteList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    var noteListBloc = serviceLocator<NoteListBloc>();

    Widget searchContainer = MySearchBar(
        controller: searchController,
        onChanged: (value) {
          noteListBloc.add(Search(value));
        });

    return BlocProvider(
      create: (arg) => noteListBloc..add(Load()),
      child: BlocBuilder<NoteListBloc, NoteListState>(
        builder: ((context, state) {
          if (state is Empty) {
            return const Center(
              child: Text('No notes saved yet. Click on "+" to add one'),
            );
          } else if (state is NotFound) {
            return Column(
              children: [
                searchContainer,
                const Expanded(
                  child: Center(
                    child:
                        Text('No note were found that matched the query above'),
                  ),
                )
              ],
            );
          } else if (state is Error) {
            return Center(child: Text(state.message));
          } else if (state is Loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is Loaded) {
            return Column(
              children: [
                searchContainer,
                Expanded(
                  child: ListView.builder(
                    itemCount: state.notes.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: ValueKey(state.notes[index]),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.endToStart) {
                            Future showDeleteSnackBar() async {
                              var snackBar = ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: const Text('Note deleted'),
                                action: SnackBarAction(
                                  label: 'Undo',
                                  onPressed: () => noteListBloc.add(Load()),
                                ),
                                duration: const Duration(seconds: 3),
                              ));
                              if (await snackBar.closed !=
                                  SnackBarClosedReason.action) {
                                await serviceLocator<DeleteNote>()(
                                    Params(id: state.notes[index].id));
                                state.notes.removeAt(index);
                                noteListBloc.add(Load());
                              }
                            }

                            showDeleteSnackBar();
                            return true;
                          }
                          return false;
                        },
                        background: Container(),
                        secondaryBackground: Container(
                          color: Colors.red,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            children: [
                              const Spacer(),
                              Image.asset(
                                'assets/gifs/white_trash_bin.gif',
                                height: 32,
                                width: 32,
                              ),
                            ],
                          ),
                        ),
                        child: NoteView(
                          note: state.notes[index],
                          openNote: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    NotePage(context, note: state.notes[index]),
                              ),
                            ).then((value) =>
                                context.read<NoteListBloc>().add(Load()));
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return Container();
        }),
      ),
    );
  }
}
