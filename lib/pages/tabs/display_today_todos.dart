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
                          final todos = folder.todos?.reversed;
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: constarints.maxHeight * 0.05,
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

class TodayTodoListItem extends StatelessWidget {
  const TodayTodoListItem({
    Key? key,
    required this.todo,
    required this.onTap,
  }) : super(key: key);

  final Todo todo;
  final void Function() onTap;

  // TODO: Add animation controller for animated text widget

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              CircularCheckBox(
                value: todo.completed,
                onTap: onTap,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedLineThroughText(
                      text: todo.title!,
                      textStyle: theme.textTheme.bodyText1,
                      value: todo.completed,
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
  }
}

class AnimatedLineThroughText extends StatelessWidget {
  const AnimatedLineThroughText({
    Key? key,
    required this.text,
    required this.textStyle,
    required this.value,
  }) : super(key: key);

  final String text;
  final bool value;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          text,
          style: textStyle,
        ),
        Container(
          transform: Matrix4.identity()..scale(0.0, 1.0),
          child: Text(
            text,
            style: textStyle?.copyWith(
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ),
      ],
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
      child: AnimatedContainer(
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: !value
              ? Border.all(
                  color: ColorUtils.blueGreyAlpha80,
                  width: 1.9,
                )
              : null,
        ),
        width: 27,
        height: 27,
        child: Opacity(
          opacity: value ? 1 : 0,
          child: Container(
            height: 27,
            width: 27,
            decoration: const BoxDecoration(
              color: ColorUtils.lightGreen,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.check,
                color: ColorUtils.white,
                size: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
