import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/extensions/my_text_editing_controller.dart';
import '../../../domain/entities/task.dart';
import '../../../injection_container.dart';
import '../../widgets/my_circular_solid_button.dart';
import '../../widgets/my_icon_button.dart';
import '../../widgets/my_solid_button.dart';
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
                  return Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
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
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              MyCircularSolidButton(
                                onPressed: () {},
                                child: SvgPicture.asset(
                                  'assets/vectors/lightbulb.svg',
                                  width: 30,
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
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 10),
                                  ),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                  focusNode: taskNameFocusNode,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: MySolidButton(
                                  child: const Text('Due Tomorrow'),
                                  onPressed: () async {
                                    await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Column(
                                          children: [
                                            const Spacer(),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    height: 400,
                                                    decoration:
                                                        const BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(50),
                                                        topRight:
                                                            Radius.circular(50),
                                                      ),
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: MySolidButton(
                                  child: const Text('Cancelled'),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            expands: true,
                            minLines: null,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            textCapitalization: TextCapitalization.sentences,
                            controller: taskDescriptionController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Add a description',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                            ),
                            focusNode: taskDescriptionFocusNode,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
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
