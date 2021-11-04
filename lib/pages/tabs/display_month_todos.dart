/*
 * Author: Gerald Addo-Tetteh
 * Todo App
 * Display Month Todos
*/
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../widgets/display_todos_boiler_plate.dart';
import '../../widgets/expantion_todo_list.dart';
import '../../models/todo_folder.dart';
import '../../models/todo.dart';
import '../../utils/constants.dart';
import '../../widgets/list_divider.dart';

class DisplayMonthTodos extends StatelessWidget {
  DisplayMonthTodos({
    Key? key,
    required this.folderKey,
  }) : super(key: key);

  final dynamic folderKey;
  final _month = DateTime.now().month;
  final _year = DateTime.now().year;

  final _monthList = [DateTime.now().month];

  void _buildMonthList() {
    for (int i = 1; i <= 11; i++) {
      int month = (_month + i) % 12;
      if (month <= 0) {
        month = 12;
      }
      _monthList.add((month));
    }
  }

  @override
  Widget build(BuildContext context) {
    _buildMonthList();
    return DisplayTodosBoilerPlate(
      child: ValueListenableBuilder<Box<TodoFolder>>(
        valueListenable:
            Hive.box<TodoFolder>(TODOS_FOLDER).listenable(keys: [folderKey]),
        builder: (context, box, _) {
          final todos = box.get(folderKey)?.todos;
          return ListView.separated(
            itemCount: 12,
            itemBuilder: (context, index) {
              return MonthTodoListItem(
                month: _monthList[index],
                year: _year,
                allTodos: todos,
              );
            },
            separatorBuilder: (context, index) => const ListDivider(),
          );
        },
      ),
    );
  }
}

class MonthTodoListItem extends StatelessWidget {
  const MonthTodoListItem({
    Key? key,
    required this.month,
    required this.year,
    required this.allTodos,
  }) : super(key: key);

  final int month;
  final int year;
  final HiveList<Todo>? allTodos;

  bool _compareDate(Todo todo) {
    final todoDate = todo.alarmDateTime;
    return todoDate?.month == month && todoDate?.year == year;
  }

  @override
  Widget build(BuildContext context) {
    final todos = allTodos?.where(_compareDate);
    return ExpantionTodoList(
      year: year,
      month: month,
      todos: todos,
      listType: TodoListType.month,
    );
  }
}
