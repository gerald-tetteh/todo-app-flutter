/*
 * Author: Gerald Addo-Tetteh
 * Todo App
 * Display Today Todos
*/

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/todo.dart';
import '../../pages/create_todo.dart';
import '../../models/todo_folder.dart';
import '../../utils/constants.dart';
import '../../widgets/list_divider.dart';
import '../../widgets/todo_list_item.dart';

class DisplayTodayTodos extends StatefulWidget {
  const DisplayTodayTodos({
    Key? key,
    required this.folderKey,
    required this.index,
    required this.todosLength,
    required this.transition,
  }) : super(key: key);

  final dynamic folderKey;
  final int index;
  final int todosLength;
  final Animation<double> transition;

  @override
  State<DisplayTodayTodos> createState() => _DisplayTodayTodosState();
}

class _DisplayTodayTodosState extends State<DisplayTodayTodos> {
  void toogleCompleted(Todo todo) {
    setState(() => todo.toogleCompleted());
    todo.save().onError((error, stackTrace) => todo.toogleCompleted());
  }

  final listSlideTween =
      Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0));

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
                  if ((widget.todosLength) == 0)
                    Text(
                      "Nothing here yet",
                      style: theme.textTheme.headline2?.copyWith(fontSize: 30),
                    ),
                  if ((widget.todosLength) > 0)
                    Expanded(
                      child: ValueListenableBuilder<Box<TodoFolder>>(
                        valueListenable: Hive.box<TodoFolder>(TODOS_FOLDER)
                            .listenable(keys: [widget.folderKey]),
                        builder: (context, box, _) {
                          final folder = box.values.elementAt(widget.index);
                          final todos = folder.todos
                              ?.where((todo) =>
                                  todo.alarmDateTime!.day == DateTime.now().day)
                              .toList()
                            ?..sort((a, b) =>
                                a.alarmDateTime!.compareTo(b.alarmDateTime!));
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: constarints.maxHeight * 0.13,
                            ),
                            child: AnimatedBuilder(
                              animation: widget.transition,
                              child: ListView.builder(
                                itemCount: todos?.length,
                                itemBuilder: (context, idx) {
                                  final todo = todos!.elementAt(idx);
                                  return TodayTodoListItem(
                                    onTap: () => toogleCompleted(todo),
                                    todo: todo,
                                  );
                                },
                              ),
                              builder: (context, child) {
                                return SlideTransition(
                                  position:
                                      widget.transition.drive(listSlideTween),
                                  child: child!,
                                );
                              },
                            ),
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
                    arguments: widget.folderKey,
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
