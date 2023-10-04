import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../../../pages/task_page/task_page.dart';
import '../../my_search_bar.dart';
import '../task_view.dart';
import 'bloc/bloc.dart';

class TaskList extends StatelessWidget {
  const TaskList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    var taskListBloc = serviceLocator<TaskListBloc>();

    Widget searchContainer = MySearchBar(
      controller: searchController,
      onChanged: (value) {
        taskListBloc.add(Search(value));
      },
    );

    return BlocProvider(
      create: (arg) => taskListBloc..add(Load()),
      child: BlocBuilder<TaskListBloc, TaskListState>(
        builder: (context, state) {
          if (state is Empty) {
            return const Center(
              child: Text('No tasks saved yet. Click on "+" to add one'),
            );
          } else if (state is NotFound) {
            return Column(
              children: [
                searchContainer,
                const Expanded(
                  child: Center(
                    child: Text('No task were found that matched the query'),
                  ),
                )
              ],
            );
          } else if (state is Error) {
            return Center(
              child: Text(state.message),
            );
          } else if (state is Loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is Loaded) {
            return Column(
              children: [
                searchContainer,
                Expanded(
                  child: ListView.separated(
                    itemCount: state.tasks.length,
                    itemBuilder: (context, index) {
                      return TaskView(
                        task: state.tasks[index],
                        openTask: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  TaskPage(context, task: state.tasks[index]),
                            ),
                          ).then((value) =>
                              context.read<TaskListBloc>().add(Load()));
                        },
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(height: 1),
                  ),
                )
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}
