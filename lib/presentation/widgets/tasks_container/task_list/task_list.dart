import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../../my_search_bar.dart';
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
            return Center(child: Text(state.message),);
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
                    itemCount: state.tasks.length,
                    itemBuilder: (context, index) {
                      
                    },
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
