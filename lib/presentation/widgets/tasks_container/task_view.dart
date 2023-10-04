import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../domain/entities/task.dart';

class TaskView extends StatelessWidget {
  final Task task;
  final Function openTask;
  const TaskView({Key? key, required this.task, required this.openTask})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      leading: CircleAvatar(
        child: task.icon == null
            ? Text(task.name.substring(0, 1))
            : SvgPicture.asset(
                task.icon!,
              ),
      ),
      title: Text(
        task.name,
        maxLines: 1,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Container(
        padding: const EdgeInsets.only(top: 8, bottom: 4),
        child: Text(
          task.description!,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ),
      enableFeedback: true,
      onTap: () async {
        await openTask();
      },
    );
  }
}
