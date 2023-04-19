import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../core/error/failure.dart';
import '../../../domain/entities/note.dart';
import '../../../injection_container.dart';
import '../../widgets/my_icon_button.dart';
import '../../widgets/my_popup_menu_item.dart';
import 'bloc/bloc.dart';

class NotePage extends StatelessWidget {
  final Note? note;
  final BuildContext ancestorContext;
  const NotePage(this.ancestorContext, {Key? key, this.note}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController noteTitleController = TextEditingController();
    TextEditingController noteContentController = TextEditingController();
    var noteBloc = serviceLocator.get<NotePageBloc>();

    Future saveNoteBeforeExit() async {
      onFailure(Failure l) {
        if (l is CacheFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Note not saved')),
          );
        }
      }

      onSuccess() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Note saved')),
        );
      }

      if (note == null) {
        noteBloc.add(Create(
          note: Note(
            id: const Uuid().v1(),
            title: noteTitleController.text,
            content: noteContentController.text,
            createdAt: DateTime.now(),
            lastEdited: DateTime.now(),
          ),
          onFailure: onFailure,
          onSuccess: onSuccess,
        ));
      } else {
        noteBloc.add(Save(
          note: Note(
            id: note!.id,
            title: noteTitleController.text,
            content: noteContentController.text,
            createdAt: note!.createdAt,
            lastEdited: noteTitleController.text == note!.title &&
                    noteContentController.text == note!.content
                ? note!.lastEdited
                : DateTime.now(),
          ),
          onFailure: onFailure,
          onSuccess: onSuccess,
        ));
      }
    }

    return Scaffold(
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            await saveNoteBeforeExit();
            return true;
          },
          child: BlocProvider(
            create: (context) => noteBloc..add(Load(note: note)),
            child: BlocBuilder<NotePageBloc, NotePageState>(
              builder: (context, state) {
                if (state is Creating || state is Editing) {
                  if (state is Editing) {
                    noteTitleController.text = state.note.title;
                    noteContentController.text = state.note.content;
                  }
                  return Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          MyIconButton(
                            iconData: Icons.arrow_back_ios,
                            onPressed: () async {
                              await saveNoteBeforeExit();
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            },
                          ),
                          const Spacer(),
                          MyIconButton(
                            iconData: Icons.more_vert,
                            onPressed: () {
                              showMenu(
                                  context: context,
                                  position: const RelativeRect.fromLTRB(
                                      100, 0, 0, 100),
                                  items: [
                                    MyPopupMenuItem(
                                      title: 'Redo',
                                      icon: Icons.redo,
                                      onClick: () {
                                        // TODO: Add logic for redo
                                      },
                                    ),
                                    MyPopupMenuItem(
                                      title: 'Undo',
                                      icon: Icons.undo,
                                      onClick: () {
                                        // TODO: Add logic for undo
                                      },
                                    ),
                                    MyPopupMenuItem(
                                      title: 'Delete',
                                      icon: Icons.delete_outline_rounded,
                                      color: Colors.red,
                                      isImportant: true,
                                      onClick: () async {
                                        bool? mustDelete =  await showDialog<bool>(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  'Do you want to delete?'),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                        context, true);
                                                  },
                                                  child: const Text('Yes'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                        context, false);
                                                  },
                                                  child: const Text('No'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                        if(mustDelete!) {
                                          // TODO: Add logic for delete notes
                                        }
                                      },
                                    ),
                                  ]);
                            },
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      TextField(
                        maxLines: 1,
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                        controller: noteTitleController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Title...',
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                        style: Theme.of(context).textTheme.headlineMedium,
                        onChanged: (value) {},
                      ),
                      Expanded(
                        child: TextField(
                          expands: true,
                          minLines: null,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          textCapitalization: TextCapitalization.sentences,
                          controller: noteContentController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Write anything...',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (state is Loading) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        CircularProgressIndicator(),
                        SizedBox(height: 10),
                        Text('Loading'),
                      ],
                    ),
                  );
                } else if (state is Saving) {
                  // TODO: Add a popup window
                  return const Center(
                    child: Text('Widget to be added'),
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
                  child: Text('Erro desconhecido'),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
