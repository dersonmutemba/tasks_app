import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/extensions/my_text_editing_controller.dart';
import '../../../domain/entities/task.dart';
import '../../../injection_container.dart';
import '../../widgets/my_icon_button.dart';
import 'bloc/bloc.dart';

class TaskPage extends StatelessWidget {
  final Task? task;
  final BuildContext ancestorContext;
  const TaskPage(this.ancestorContext, {Key? key, this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late MyTextEditingController focusedController;
    MyTextEditingController taskNameController = MyTextEditingController();
    FocusNode taskNameFocusNode = FocusNode()
      ..addListener(() => focusedController = taskNameController);
    MyTextEditingController taskDescriptionController =
        MyTextEditingController();
    FocusNode taskDescriptionFocusNode = FocusNode()
      ..addListener(() => focusedController = taskDescriptionController);
    var taskBloc = serviceLocator<TaskPageBloc>();

    return Scaffold(
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            // TODO: Add logic for pop
            return true;
          },
          child: BlocProvider(
            create: (context) => taskBloc..add(Load(task: task)),
            child: BlocBuilder<TaskPageBloc, TaskPageState>(
              builder: (context, state) {
                if (state is Creating || state is Editing) {
                  if (state is Editing) {
                    taskNameController.text = state.task.name;
                    taskDescriptionController.text = state.task.description!;
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
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            },
                          ),
                          const Spacer(),
                          MyIconButton(
                            iconData: Icons.more_vert,
                            tooltip: 'More options',
                            onPressed: () {},
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.blue,
                              ),
                              height: 40,
                              width: 40,
                              child: const Icon(
                                Icons.photo_outlined,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextField(
                                maxLines: 1,
                                keyboardType: TextInputType.text,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                controller: taskNameController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Name...',
                                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                                ),
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                                focusNode: taskNameFocusNode,
                              ),
                            )
                          ],
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
