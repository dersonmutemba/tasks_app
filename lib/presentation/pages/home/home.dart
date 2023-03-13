import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/bloc.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc(),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: ((context, state) {
              return TextButton(
                onPressed: () {
                  if (state is SelectedTasksHome) {
                    context.read<HomeBloc>().add(NotesHomeSelected());
                  } else if (state is SelectedNotesHome) {
                    context.read<HomeBloc>().add(TasksHomeSelected());
                  }
                },
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).textTheme.bodyLarge!.color,
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
              );
            }),
          ),
        ),
        floatingActionButton: ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
            shape: MaterialStateProperty.all(const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15)))),
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
      ),
    );
  }
}
