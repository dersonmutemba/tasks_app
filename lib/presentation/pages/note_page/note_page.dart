import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

import '../../../core/error/failure.dart';
import '../../../core/extensions/my_text_editing_controller.dart';
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
    late MyTextEditingController focusedController;
    MyTextEditingController noteTitleController = MyTextEditingController();
    FocusNode noteTitleFocusNode = FocusNode()
      ..addListener(() => focusedController = noteTitleController);
    MyTextEditingController noteContentController = MyTextEditingController();
    FocusNode noteContentFocusNode = FocusNode()
      ..addListener(() => focusedController = noteContentController);
    var noteBloc = serviceLocator<NotePageBloc>();

    Future saveNoteBeforeExit() async {
      onFailure(Failure l) {
        if (l is CacheFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Note not saved')),
          );
        }
      }

      onSuccess() {}

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
                            tooltip: 'Go back',
                            onPressed: () async {
                              await saveNoteBeforeExit();
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            },
                          ),
                          const Spacer(),
                          MyIconButton(
                            iconData: Icons.ios_share_rounded,
                            tooltip: 'Share',
                            onPressed: () {
                              Share.share(
                                '${noteTitleController.text}\n\n${noteContentController.text}',
                                subject: noteTitleController.text,
                              );
                            },
                          ),
                          MyIconButton(
                            iconData: Icons.more_vert,
                            tooltip: 'More options',
                            onPressed: () {
                              showMenu(
                                  context: context,
                                  position: const RelativeRect.fromLTRB(
                                      100, 0, 0, 100),
                                  items: [
                                    MyPopupMenuItem(
                                      title: 'Undo',
                                      icon: Icons.undo,
                                      onClick: () {
                                        focusedController.undo();
                                      },
                                    ),
                                    MyPopupMenuItem(
                                      title: 'Redo',
                                      icon: Icons.redo,
                                      onClick: () {
                                        focusedController.redo();
                                      },
                                    ),
                                    MyPopupMenuItem(
                                      title: 'Delete',
                                      icon: Icons.delete_outline_rounded,
                                      color: Colors.red,
                                      isImportant: true,
                                      isEnabled: note != null,
                                      onClick: () {
                                        Future.delayed(
                                            const Duration(seconds: 0),
                                            () async {
                                          bool? mustDelete = await showDialog<
                                                  bool>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        'Do you want to delete?'),
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5)),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context, true);
                                                        },
                                                        child:
                                                            const Text('Yes'),
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
                                              ) ??
                                              false;
                                          if (mustDelete) {
                                            noteBloc.add(Delete(note!.id));
                                            if (context.mounted) {
                                              Navigator.pop(context);
                                            }
                                          }
                                        });
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
                        focusNode: noteTitleFocusNode,
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
                          focusNode: noteContentFocusNode,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
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
