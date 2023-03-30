import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/contracts/note_contract.dart';
import '../../../domain/entities/note.dart';
import '../../../injection_container.dart';
import '../../widgets/my_icon_button.dart';
import 'bloc/bloc.dart';

class NotePage extends StatelessWidget {
  final String? id;
  const NotePage({Key? key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _NotePageContent(id: id),
      ),
    );
  }
}

class _NotePageContent extends StatefulWidget {
  final String? id;
  const _NotePageContent({Key? key, required this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NotePageContentState();
}

class _NotePageContentState extends State<_NotePageContent> {
  final TextEditingController noteTitleController = TextEditingController();
  final TextEditingController noteContentController = TextEditingController();
  Note? note;
  var noteBloc =
      NotePageBloc(noteRepository: serviceLocator.get<NoteContract>());

  @override
  void dispose() {
    if (note == null) {
      var noteRepository = serviceLocator.get<NoteContract>();
      noteRepository.insertNote(Note(
        id: const Uuid().v1(),
        title: noteTitleController.text,
        content: noteContentController.text,
        createdAt: DateTime.now(),
        lastEdited: DateTime.now(),
      ));
    } else {
      throw Exception();
      // TODO: Add logic for saving edited notes
    }
    noteTitleController.dispose();
    noteContentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => noteBloc,
      child: BlocBuilder<NotePageBloc, NotePageState>(
        builder: (context, state) {
          if (widget.id != null) {
            context.read<NotePageBloc>().add(Load());
          }
          if (state is Creating || state is Editing) {
            if (state is Editing) {
              note = state.note;
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
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Spacer(),
                    MyIconButton(
                      iconData: Icons.more_vert,
                      onPressed: () {
                        // TODO: Add a popup menu and some options
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
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                ),
              ],
            );
          } else if (state is Loading) {
            return Center(
              child: Column(
                children: const [
                  CircularProgressIndicator(),
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
            // TODO: Add a popup window
            return Container(
              color: Colors.red,
              child: Center(
                child: Text('Error: ${state.message}'),
              ),
            );
          } else if (state is Saved) {
            // TODO: Add a popup window
            return Center(
              child: Text(state.message),
            );
          }
          return const Center(
            child: Text('Erro desconhecido'),
          );
        },
      ),
    );
  }
}
