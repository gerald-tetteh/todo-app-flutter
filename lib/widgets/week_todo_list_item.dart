/*
 * Author: Gerald Addo-Tetteh
 * Todo App
 * Week Todo List Item
*/
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/todo.dart';

import './expantion_todo_list.dart';

class WeekTodoListItem extends StatelessWidget {
  const WeekTodoListItem({
    Key? key,
    required this.day,
    required this.month,
    required this.year,
    required this.allTodos,
  }) : super(key: key);

  final int day;
  final int month;
  final int year;
  final HiveList<Todo>? allTodos;

  bool _compareDate(Todo todo) {
    final todoDate = todo.alarmDateTime;
    return todoDate?.day == day &&
        todoDate?.month == month &&
        todoDate?.year == year;
  }

  @override
  Widget build(BuildContext context) {
    final todos = allTodos?.where(_compareDate);
    return ExpantionTodoList(
      day: day,
      year: year,
      month: month,
      todos: todos,
    );
  }
}
