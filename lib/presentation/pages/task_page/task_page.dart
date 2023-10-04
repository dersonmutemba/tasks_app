import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tasks_app/presentation/widgets/my_popup_container.dart';
import 'package:uuid/uuid.dart';

import '../../../core/error/failure.dart';
import '../../../core/extensions/my_text_editing_controller.dart';
import '../../../domain/entities/enumuration/status.dart';
import '../../../domain/entities/task.dart';
import '../../../injection_container.dart';
import '../../widgets/my_circular_solid_button.dart';
import '../../widgets/my_icon_button.dart';
import '../../widgets/my_solid_button.dart';
import 'bloc/bloc.dart';

class TaskPage extends StatefulWidget {
  final Task? task;
  final BuildContext ancestorContext;
  const TaskPage(this.ancestorContext, {Key? key, this.task}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  late MyTextEditingController focusedController;
  MyTextEditingController taskNameController = MyTextEditingController();
  MyTextEditingController taskDescriptionController = MyTextEditingController();
  var taskBloc = serviceLocator<TaskPageBloc>();

  late String icon;
  late DateTime dueDate;
  late Status status;

  @override
  void initState() {
    // TODO: Add possibility of icon and dueDate be null
    icon = widget.task == null || widget.task!.icon == null
        ? 'assets/vectors/lightbulb.svg'
        : widget.task!.icon!;
    dueDate = widget.task == null || widget.task!.dueDate == null
        ? DateTime.now().add(const Duration(days: 1))
        : widget.task!.dueDate!;
    status = widget.task == null ? Status.notStarted : widget.task!.status;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FocusNode taskNameFocusNode = FocusNode()
      ..addListener(() => focusedController = taskNameController);
    FocusNode taskDescriptionFocusNode = FocusNode()
      ..addListener(() => focusedController = taskDescriptionController);

    Future saveTaskBeforeExit() async {
      onFailure(Failure l) {
        if (l is CacheFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Task not saved')),
          );
        }
      }

      onSuccess() {}

      if (widget.task == null) {
        taskBloc.add(Create(
          task: Task(
            id: const Uuid().v1(),
            name: taskNameController.text,
            description: taskDescriptionController.text,
            icon: icon,
            createdAt: DateTime.now(),
            lastEdited: DateTime.now(),
            startedAt: status == Status.doing ? DateTime.now() : null,
            dueDate: dueDate,
            status: status,
          ),
          onFailure: onFailure,
          onSuccess: onSuccess,
        ));
      } else {
        taskBloc.add(Save(
          task: Task(
            id: widget.task!.id,
            name: taskNameController.text,
            description: taskDescriptionController.text,
            icon: icon,
            createdAt: widget.task!.createdAt,
            lastEdited: taskNameController.text == widget.task!.name &&
                    taskDescriptionController.text ==
                        widget.task!.description &&
                    icon == widget.task!.icon &&
                    dueDate == widget.task!.dueDate &&
                    status == widget.task!.status
                ? widget.task!.lastEdited
                : DateTime.now(),
            startedAt: _handleStartedAt(status),
            dueDate: dueDate,
            status: status,
          ),
          onFailure: onFailure,
          onSuccess: onSuccess,
        ));
      }
    }

    return Scaffold(
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            await saveTaskBeforeExit();
            return true;
          },
          child: BlocProvider(
            create: (context) => taskBloc..add(Load(task: widget.task)),
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
                                await saveTaskBeforeExit();
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
                                  icon,
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
                                  child:
                                      Text('Due ${_resolveDateTime(dueDate)}'),
                                  onPressed: () async {
                                    dueDate = (await showDatePicker(
                                          context: context,
                                          initialDate: dueDate,
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime(2099),
                                        )) ??
                                        dueDate;
                                    setState(() {});
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: MySolidButton(
                                  child: Text(status.name.toString()),
                                  onPressed: () async {
                                    status = (await showDialog<Status>(
                                      context: context,
                                      builder: (context) {
                                        List<Status> statuses = Status.values;
                                        return MyPopupContainer(
                                          child: ListView.builder(
                                            itemCount: statuses.length,
                                            itemBuilder: (context, index) {
                                              return TextButton(
                                                child: Text(statuses[index]
                                                    .name
                                                    .toString()),
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(statuses[index]),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ))!;
                                    setState(() {});
                                  },
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

  String _resolveDateTime(DateTime dateTime) {
    DateTime now = DateTime.now();
    if (now.month == dateTime.month && now.year == dateTime.year) {
      if (now.day == dateTime.day) return 'Today';
      if (now.day == dateTime.day - 1) return 'Tomorrow';
    }
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  DateTime? _handleStartedAt(Status status) {
    if (![Status.aborted, Status.notStarted, Status.unknown].contains(status)) {
      if (status == widget.task!.status) return widget.task!.startedAt;
      if (status == Status.doing) return DateTime.now();
    }
    return null;
  }
}
