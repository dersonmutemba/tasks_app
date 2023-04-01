import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/notes_container/note_list/note_list.dart';
import '../note_page/note_page.dart';
import 'bloc/bloc.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: ((context, state) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextButton(
                    onPressed: () {
                      if (state is SelectedTasksHome) {
                        context.read<HomeBloc>().add(NotesHomeSelected());
                      } else if (state is SelectedNotesHome) {
                        context.read<HomeBloc>().add(TasksHomeSelected());
                      }
                    },
                    style: TextButton.styleFrom(
                      foregroundColor:
                          Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                    child: SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            state.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Column(
                            children: const [
                              Icon(Icons.keyboard_arrow_up_rounded),
                              Icon(Icons.keyboard_arrow_down_rounded)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ] + _getWidgetsByState(state),
              ),
            ),
            floatingActionButton: ElevatedButton(
              onPressed: () {
                if (state is SelectedTasksHome) {
                  // TODO: Add code for fab click on task
                } else if (state is SelectedNotesHome) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const NotePage(),
                    ),
                  );
                }
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)))),
              ),
              child: Container(
                height: 40,
                width: 40,
                padding: EdgeInsets.zero,
                child: const Icon(
                  Icons.add_rounded,
                  size: 30,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  List<Widget> _getWidgetsByState(HomeState state) {
    if(state is SelectedNotesHome) {
      return const[Expanded(child: NoteList())];
    }
    return [];
  }
}
