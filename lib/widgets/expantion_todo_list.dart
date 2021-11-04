/*
 * Author: Gerald Addo-Tetteh
 * Todo App
 * Expantion Todo List
*/
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/todo.dart';
import '../helpers/functions.dart';
import '../utils/color_utils.dart';

import './circular_check_box.dart';

enum TodoListType { week, month }

class ExpantionTodoList extends StatefulWidget {
  const ExpantionTodoList({
    Key? key,
    this.day = 0,
    required this.month,
    required this.todos,
    required this.year,
    this.listType = TodoListType.week,
  }) : super(key: key);

  final Iterable<Todo>? todos;
  final int day;
  final int month;
  final int year;
  final TodoListType listType;

  @override
  _ExpantionTodoListState createState() => _ExpantionTodoListState();
}

class _ExpantionTodoListState extends State<ExpantionTodoList>
    with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  late final AnimationController _controller;
  final _textWidgetKey = GlobalKey();
  double _textWidth = 0.0;

  void _toggleOpen() {
    setState(() => _isOpen = !_isOpen);
    if (_isOpen) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void _toogleCompleted(Todo todo) {
    setState(() => todo.toogleCompleted());
    todo.save().onError((error, stackTrace) => todo.toogleCompleted());
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
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width - (70);
    var titleText = Text(
      widget.listType == TodoListType.week
          ? getTodayText(widget.year, widget.month, widget.day)
          : getMonthText(widget.month),
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
        color: Colors.transparent,
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
                  child: titleText,
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
              firstChild: const SizedBox(),
              secondChild: Column(
                children: widget.todos
                        ?.map(
                          (todo) => Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                            ),
                            child: Row(
                              children: [
                                CircularCheckBox(
                                  onTap: () => _toogleCompleted(todo),
                                  value: todo.completed,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                // expanded prevents overflow error.
                                Expanded(
                                  child: Text(
                                    todo.title!,
                                    style: theme.textTheme.bodyText2?.copyWith(
                                      decoration: todo.completed
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                      color: todo.completed
                                          ? ColorUtils.blueGreyAlpha80
                                          : null,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  buildTimeString(todo),
                                  style: theme.textTheme.caption?.copyWith(
                                    color: ColorUtils.black.withAlpha(90),
                                  ),
                                ),
                              ],
                            ),
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
