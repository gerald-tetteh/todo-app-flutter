/*
 * Author: Gerald Addo-Tetteh
 * Todo App
 * All Todos
*/
import 'package:flutter/material.dart';

import '../utils/color_utils.dart';
import '../models/todo_folder.dart';
import '../widgets/scaffold_boiler_plate.dart';
import '../widgets/backgound_stack_with_anim.dart';

class FolderView extends StatefulWidget {
  const FolderView({
    Key? key,
    this.transitionAnimation,
    required this.todoFolder,
  }) : super(key: key);

  static const routeName = "/all-todos";
  final Animation<double>? transitionAnimation;
  final TodoFolder todoFolder;

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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  controller: _tabController,
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      Icon(Icons.directions_car),
                      Icon(Icons.directions_transit),
                      Icon(Icons.directions_bike),
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
