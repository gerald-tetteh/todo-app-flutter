/*
 * Author: Gerald Addo-Tetteh
 * Todo App
 * All Todos
*/
import 'package:flutter/material.dart';

import '../widgets/scaffold_boiler_plate.dart';
import '../widgets/backgound_stack_with_anim.dart';

class FolderView extends StatelessWidget {
  const FolderView({
    Key? key,
    this.transitionAnimation,
    required this.tag,
  }) : super(key: key);

  static const routeName = "/all-todos";
  final Animation<double>? transitionAnimation;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return BackgroundStackWithAnim(
      transitionAnimation: transitionAnimation,
      // TODO: Complete Folder View
      content: ScaffoldBoilerPlate(
        content: const Text("hello"),
        transitionAnimation: transitionAnimation!,
        tag: tag,
      ),
    );
  }
}
