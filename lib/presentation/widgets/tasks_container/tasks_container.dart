import 'package:flutter/widgets.dart';

import 'task_list/task_list.dart';

class TasksContainer extends StatelessWidget {
  const TasksContainer({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [Expanded(child: TaskList())],
    );
  }
}