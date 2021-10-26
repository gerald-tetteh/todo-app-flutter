/*
 * Author: Gerald Addo-Tetteh
 * Todo App
 * Display Today Todos
*/

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../pages/create_todo.dart';
import '../../models/todo_folder.dart';
import '../../utils/constants.dart';
import '../../utils/color_utils.dart';

class DisplayTodayTodos extends StatelessWidget {
  const DisplayTodayTodos({
    Key? key,
    required this.folderKey,
    required this.index,
    required this.todosLength,
  }) : super(key: key);

  final dynamic folderKey;
  final int index;
  final int todosLength;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constarints) {
        return Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Column(
                children: [
                  const ListDivider(),
                  if ((todosLength) == 0)
                    Text(
                      "Nothing here yet",
                      style: theme.textTheme.headline2?.copyWith(fontSize: 30),
                    ),
                  if ((todosLength) > 0)
                    Expanded(
                      child: ValueListenableBuilder<Box<TodoFolder>>(
                        valueListenable: Hive.box<TodoFolder>(TODOS_FOLDER)
                            .listenable(keys: [folderKey]),
                        builder: (context, box, _) {
                          final folder = box.values.elementAt(index);
                          final todos = folder.todos;
                          return ListView.builder(
                            itemCount: todos?.length,
                            itemBuilder: (context, idx) {
                              return Text("${todos?.elementAt(idx).title}");
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
              Positioned(
                bottom: constarints.maxHeight * 0.05,
                left: (constarints.maxWidth / 2) -
                    ((0.05 * constarints.maxWidth) + 20),
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed(CreateTodo.routeName),
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: EdgeInsets.all(
                      0.05 * constarints.maxHeight,
                    ),
                  ),
                  child: const FaIcon(
                    FontAwesomeIcons.plus,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ListDivider extends StatelessWidget {
  const ListDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: 1.3,
      color: ColorUtils.blueGreyAlpha80,
    );
  }
}
