/*
 * Author: Gerald Addo-Tetteh
 * Todo App
 * Display Week Todos
*/
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/todo_folder.dart';
import '../../utils/constants.dart';
import '../../widgets/list_divider.dart';
import '../../widgets/week_todo_list_item.dart';
import '../../widgets/display_todos_boiler_plate.dart';

class DisplayWeekTodos extends StatelessWidget {
  DisplayWeekTodos({
    Key? key,
    required this.folderKey,
  }) : super(key: key);

  final dynamic folderKey;
  final _today = DateTime.now().day;
  final _month = DateTime.now().month;
  final _year = DateTime.now().year;

  final _weekDaysList = [DateTime.now().day];

  void _buildWeekDayList() {
    for (int i = 1; i <= 6; i++) {
      _weekDaysList.add(_today + i);
    }
  }

  @override
  Widget build(BuildContext context) {
    _buildWeekDayList();
    return DisplayTodosBoilerPlate(
      child: ValueListenableBuilder<Box<TodoFolder>>(
        valueListenable:
            Hive.box<TodoFolder>(TODOS_FOLDER).listenable(keys: [folderKey]),
        builder: (context, box, _) {
          final todos = box.get(folderKey)?.todos;
          return ListView.separated(
            itemCount: 7,
            itemBuilder: (context, index) {
              return WeekTodoListItem(
                month: _month,
                year: _year,
                day: _weekDaysList[index],
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
