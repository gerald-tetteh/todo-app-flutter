/*
 * Author: Gerald Addo-Tetteh
 * Todo App
 * All Todos
*/
import 'package:flutter/material.dart';

import '../utils/color_utils.dart';
import '../utils/circle_tab_indicator.dart';
import '../models/todo_folder.dart';
import '../widgets/scaffold_boiler_plate.dart';
import '../widgets/backgound_stack_with_anim.dart';

import './tabs/display_month_todos.dart';
import './tabs/display_week_todos.dart';
import './tabs/display_today_todos.dart';

class FolderView extends StatefulWidget {
  const FolderView({
    Key? key,
    this.transitionAnimation,
    required this.todoFolder,
    required this.index,
  }) : super(key: key);

  static const routeName = "/all-todos";
  final Animation<double>? transitionAnimation;
  final TodoFolder todoFolder;
  final int index;

  @override
  State<FolderView> createState() => _FolderViewState();
}

class _FolderViewState extends State<FolderView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ThemeData _theme;
  late List<Widget> _tabs;

  List<Widget> makeTabs() {
    return [
      Text(
        "Today",
        style: _theme.textTheme.headline2,
      ),
      Text(
        "Week",
        style: _theme.textTheme.headline2,
      ),
      Text(
        "Month",
        style: _theme.textTheme.headline2,
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    _tabs = makeTabs();
    return BackgroundStackWithAnim(
      transitionAnimation: widget.transitionAnimation,
      // TODO: Complete Folder View
      content: ScaffoldBoilerPlate(
        transitionAnimation: widget.transitionAnimation!,
        tag: widget.todoFolder.name!,
        title: widget.todoFolder.name! == "All"
            ? "All To Do's"
            : widget.todoFolder.name!,
        content: Material(
          color: ColorUtils.white,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 25,
              left: 20,
              right: 20,
              bottom: 10,
            ),
            child: Column(
              children: [
                TabBar(
                  tabs: _tabs,
                  controller: _tabController,
                  indicator: const CircleIndicator(
                    color: ColorUtils.lightGreen,
                    radius: 4,
                  ),
                  isScrollable: false,
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      DisplayTodayTodos(
                        folderKey: widget.todoFolder.key,
                        index: widget.index,
                        todosLength: widget.todoFolder.todos?.length ?? 0,
                        transition: widget.transitionAnimation!,
                      ),
                      DisplayWeekTodos(
                        folderKey: widget.todoFolder.key,
                      ),
                      const DisplayMonthTodos(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
