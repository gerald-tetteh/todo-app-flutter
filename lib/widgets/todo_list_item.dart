/*
 * Author: Gerald Addo-Tetteh
 * Todo App
 * Todo List Item
*/
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/todo.dart';
import '../utils/color_utils.dart';

import './list_divider.dart';
import './circular_check_box.dart';

class TodayTodoListItem extends StatelessWidget {
  const TodayTodoListItem({
    Key? key,
    required this.todo,
    required this.onTap,
  }) : super(key: key);

  final Todo todo;
  final void Function() onTap;

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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todo.title!,
                        style: theme.textTheme.bodyText1?.copyWith(
                          decoration: todo.completed
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: todo.completed
                              ? ColorUtils.blueGreyAlpha80
                              : null,
                        ),
                        overflow: TextOverflow.ellipsis,
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
              ),
            ],
          ),
        ),
        const ListDivider(),
      ],
    );
  }
}
