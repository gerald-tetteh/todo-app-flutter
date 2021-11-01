/*
 * Author: Gerald Addo-Tetteh
 * Todo App
 * Display Week Todos
*/
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/widgets/circular_check_box.dart';

import '../../utils/color_utils.dart';
import '../../models/todo_folder.dart';
import '../../models/todo.dart';
import '../../utils/constants.dart';
import '../../widgets/list_divider.dart';

class DisplayWeekTodos extends StatefulWidget {
  const DisplayWeekTodos({
    Key? key,
    required this.folderKey,
  }) : super(key: key);

  final dynamic folderKey;

  @override
  State<DisplayWeekTodos> createState() => _DisplayWeekTodosState();
}

class _DisplayWeekTodosState extends State<DisplayWeekTodos> {
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
  void initState() {
    super.initState();
    _buildWeekDayList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        children: [
          const ListDivider(),
          Expanded(
            child: ValueListenableBuilder<Box<TodoFolder>>(
              valueListenable: Hive.box<TodoFolder>(TODOS_FOLDER)
                  .listenable(keys: [widget.folderKey]),
              builder: (context, box, _) {
                final todos = box.get(widget.folderKey)?.todos;
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
          ),
        ],
      ),
    );
  }
}

class WeekTodoListItem extends StatefulWidget {
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

  @override
  State<WeekTodoListItem> createState() => _WeekTodoListItemState();
}

class _WeekTodoListItemState extends State<WeekTodoListItem>
    with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  final _textWidgetKey = GlobalKey();
  double _textWidth = 0.0;
  late final AnimationController _controller;

  bool _compareDate(Todo todo) {
    final todoDate = todo.alarmDateTime;
    return todoDate?.day == widget.day &&
        todoDate?.month == widget.month &&
        todoDate?.year == widget.year;
  }

  String _getTodayText() {
    final currentDay = DateTime(widget.year, widget.month, widget.day);
    switch (currentDay.weekday) {
      case DateTime.monday:
        return "Monday";
      case DateTime.tuesday:
        return "Tuesday";
      case DateTime.wednesday:
        return "Wednesday";
      case DateTime.thursday:
        return "Thursday";
      case DateTime.friday:
        return "Friday";
      case DateTime.saturday:
        return "Saturday";
      case DateTime.sunday:
        return "Sunday";
      default:
        return "";
    }
  }

  void _toggleOpen() {
    setState(() => _isOpen = !_isOpen);
    if (_isOpen) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    final todayTodos = widget.allTodos?.where(_compareDate);
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width - (70);
    // TODO: fix gesture detecter and complete page
    var weekDayText = Text(
      _getTodayText(),
      key: _textWidgetKey,
      style: theme.textTheme.headline3,
    );
    Future.delayed(const Duration(seconds: 0), () {
      if (mounted) {
        setState(() {
          _textWidth =
              (_textWidgetKey.currentContext?.findRenderObject() as RenderBox)
                  .size
                  .width;
        });
      }
    });
    final _offsetWidth = (width - _textWidth) / 2;
    return GestureDetector(
      onTap: _toggleOpen,
      child: AnimatedContainer(
        padding: const EdgeInsets.all(15),
        duration: const Duration(milliseconds: 500),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Transform.translate(
                  offset: Offset(_offsetWidth * _controller.value, 0.0),
                  child: weekDayText,
                ),
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  firstChild: const FaIcon(
                    FontAwesomeIcons.plus,
                    color: ColorUtils.lightGreen,
                    size: 14,
                  ),
                  secondChild: const FaIcon(
                    FontAwesomeIcons.minus,
                    color: ColorUtils.lightGreen,
                    size: 14,
                  ),
                  crossFadeState: _isOpen
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                ),
              ],
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox(
                width: double.infinity,
              ),
              secondChild: Column(
                children: todayTodos
                        ?.map(
                          (todo) => Row(
                            children: [
                              CircularCheckBox(
                                onTap: () {},
                                value: true,
                              ),
                              Text(todo.title!),
                              const Spacer(),
                              Text("${todo.alarmDateTime!}"),
                            ],
                          ),
                        )
                        .toList() ??
                    [],
              ),
              duration: const Duration(milliseconds: 500),
              crossFadeState: _isOpen
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
          ],
        ),
      ),
    );
  }
}
