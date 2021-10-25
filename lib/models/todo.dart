/*
 * Author: Gerald Addo-Tetteh
 * Todo App
 * Todo Model
*/

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'todo.g.dart';

enum Priority { high, medium, low }

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
  @HiveField(6)
  final TimeOfDay? alarmTimeOfDay;
  @HiveField(7)
  final DateTime? alarmDateTime;

  Todo({
    this.title,
    this.notes,
    this.imagePath,
    this.priority = Priority.low,
    DateTime? dateCreated,
    this.setAlarm = false,
    this.alarmDateTime,
    this.alarmTimeOfDay,
  }) : dateCreated = dateCreated ?? DateTime.now();
}
