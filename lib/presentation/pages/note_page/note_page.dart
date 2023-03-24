import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/contracts/note_contract.dart';
import '../../../injection_container.dart';
import '../../widgets/my_icon_button.dart';
import 'bloc/bloc.dart';

class NotePage extends StatelessWidget {
  final String? id;
  const NotePage({Key? key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _noteTitleController = TextEditingController();
    final TextEditingController _noteContentController =
        TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) =>
              NotePageBloc(noteRepository: serviceLocator.get<NoteContract>()),
          child: BlocBuilder<NotePageBloc, NotePageState>(
            builder: (context, state) {
              if (id != null) {
                context.read<NotePageBloc>().add(Load());
              }
              if (state is Creating || state is Editing) {
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
                      controller: _noteTitleController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Title...',
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Expanded(
                      child: TextField(
                        expands: true,
                        minLines: null,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        textCapitalization: TextCapitalization.sentences,
                        controller: _noteContentController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Write anything...',
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: OutlinedButton(
                        onPressed: () {
                          context.read<NotePageBloc>().add(Save(noteProps: {
                                'title': _noteTitleController.text,
                                'content': _noteContentController.text,
                                'date': state is Editing
                                    ? state.note.createdAt
                                    : DateTime.now(),
                              }));
                        },
                        child: const Text('Save'),
                      ),
                    )
                  ],
                );
              } else if (state is Loading) {
                return const Center(
                  child: Column(
                    children: [
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
        ),
      ),
    );
  }
}
