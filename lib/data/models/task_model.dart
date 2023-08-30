import '../../domain/entities/task_exp.dart';

class TaskModel extends Task {
  TaskModel({
    required String id,
    required String name,
    String? description,
    String? icon,
    required DateTime createdAt,
    DateTime? lastEdited,
    DateTime? startedAt,
    DateTime? dueDate,
    required Status status,
  }) : super(
          id: id,
          name: name,
          description: description,
          icon: icon,
          createdAt: createdAt,
          lastEdited: lastEdited,
          startedAt: startedAt,
          dueDate: dueDate,
          status: status,
        );

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        icon: json['icon'],
        createdAt: DateTime.parse(json['createdAt']),
        lastEdited: json['lastEdited'] != null
            ? DateTime.parse(json['lastEdited'])
            : null,
        startedAt: json['startedAt'] != null
            ? DateTime.parse(json['startedAt'])
            : null,
        dueDate:
            json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
        status: statusFromString(json['status']) ?? Status.unknown,
      );

  factory TaskModel.fromTask(Task task) => TaskModel(
        id: task.id,
        name: task.name,
        description: task.description,
        icon: task.icon,
        createdAt: task.createdAt,
        lastEdited: task.lastEdited,
        startedAt: task.startedAt,
        dueDate: task.dueDate,
        status: task.status,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'icon': icon,
        'createdAt': createdAt.toIso8601String(),
        'lastEdited': lastEdited?.toIso8601String(),
        'startedAt': startedAt?.toIso8601String(),
        'dueDate': dueDate?.toIso8601String(),
        'status': status.toString(),
      };
}
