import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/my_bottom_navbar_button.dart';
import '../../widgets/notes_container/notes_container.dart';
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
                  Container(
                    padding: const EdgeInsets.all(30),
                    alignment: Alignment.center,
                    child: Text(
                      state.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Expanded(
                    child: _getWidgetsByState(state) ?? const SizedBox(),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: _getBottomNavigationBar(state, context),
            floatingActionButton: ElevatedButton(
              onPressed: () async {
                context.read<HomeBloc>().add(Dismiss());
                if (state is SelectedTasksHome) {
                  // TODO: Add code for fab click on task
                } else if (state is SelectedNotesHome) {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext notePageContext) =>
                          NotePage(context),
                    ),
                  ).then((value) {
                    context.read<HomeBloc>().add(NotesHomeSelected());
                  });
                  // I must see how to refresh info using state
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

  Widget? _getWidgetsByState(HomeState state) {
    if (state is SelectedNotesHome) {
      return const NotesContainer();
    }
    return null;
  }

  Widget _getBottomNavigationBar(HomeState state, BuildContext context) {
    return Container(
      height: 55,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey, width: .5))
      ),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            child: MyBottomNavBarButton(
              icon: Icons.add_task_sharp,
              onPressed: () {
                context.read<HomeBloc>().add(TasksHomeSelected());
              },
              text: 'Tasks',
              isEmphasized: state is SelectedTasksHome,
            ),
          ),
          Expanded(
            child: MyBottomNavBarButton(
              icon: Icons.edit_note_rounded,
              onPressed: () {
                context.read<HomeBloc>().add(NotesHomeSelected());
              },
              text: 'Notes',
              isEmphasized: state is SelectedNotesHome,
            ),
          ),
        ],
      ),
    );
  }
}
