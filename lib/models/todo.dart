/*
 * Author: Gerald Addo-Tetteh
 * Todo App
 * Todo Model
*/

import 'package:hive/hive.dart';

import './priority.dart';

part 'todo.g.dart';

@HiveType(typeId: 2)
class Todo extends HiveObject {
  @HiveField(0)
  final String? title;
  @HiveField(1)
  final String? notes;
  @HiveField(2)
  final String? imagePath;
  @HiveField(3)
  final Priority priority;
  @HiveField(4)
  final DateTime dateCreated;
  @HiveField(5)
  final bool setAlarm;
  @HiveField(7)
  final DateTime? alarmDateTime;
  @HiveField(9)
  bool completed;
  @HiveField(10)
  final int? notificationId;

  Todo({
    this.title,
    this.notes,
    this.imagePath,
    this.priority = Priority.low,
    DateTime? dateCreated,
    this.setAlarm = false,
    this.alarmDateTime,
    this.completed = false,
    this.notificationId,
  }) : dateCreated = dateCreated ?? DateTime.now();

  void toogleCompleted() {
    completed = !completed;
  }
}
