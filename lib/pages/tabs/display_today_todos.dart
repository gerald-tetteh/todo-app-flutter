/*
 * Author: Gerald Addo-Tetteh
 * Todo App
 * Display Today Todos
*/

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../../models/todo.dart';
import '../../utils/color_utils.dart';
import '../../pages/create_todo.dart';
import '../../models/todo_folder.dart';
import '../../utils/constants.dart';
import '../../widgets/list_divider.dart';

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

  void toogleCompleted(Todo todo) {}

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
                          final todos = folder.todos?.reversed;
                          return ListView.builder(
                            itemCount: todos?.length,
                            itemBuilder: (context, idx) {
                              final todo = todos!.elementAt(idx);
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Row(
                                      children: [
                                        CircularCheckBox(
                                          value: todo.completed,
                                          onTap: () {},
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                todo.title!,
                                                style:
                                                    theme.textTheme.bodyText1,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                DateFormat.jm().format(
                                                  todo.alarmDateTime!,
                                                ),
                                                style: theme.textTheme.caption,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const ListDivider(),
                                ],
                              );
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
                  onPressed: () => Navigator.of(context).pushNamed(
                    CreateTodo.routeName,
                    arguments: folderKey,
                  ),
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

class CircularCheckBox extends StatelessWidget {
  const CircularCheckBox({
    Key? key,
    required this.value,
    required this.onTap,
  }) : super(key: key);

  final bool value;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: ColorUtils.blueGreyAlpha80,
            width: 1.9,
          ),
        ),
        width: 27,
        height: 27,
        child: AnimatedCrossFade(
          firstChild: const SizedBox(
            height: double.infinity,
            width: double.infinity,
          ),
          secondChild: Container(
            color: ColorUtils.lightGreen,
            child: const FaIcon(FontAwesomeIcons.check),
          ),
          crossFadeState:
              value ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(microseconds: 700),
        ),
      ),
    );
  }
}
