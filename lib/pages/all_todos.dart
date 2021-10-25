/*
 * Author: Gerald Addo-Tetteh
 * Todo App
 * All Todos
*/
import 'package:flutter/material.dart';

import '../widgets/backgound_stack_with_anim.dart';

class AllTodos extends StatelessWidget {
  const AllTodos({
    Key? key,
    this.transitionAnimation,
  }) : super(key: key);

  static const routeName = "/all-todos";
  final Animation<double>? transitionAnimation;

  @override
  Widget build(BuildContext context) {
    return BackgroundStackWithAnim(
      transitionAnimation: transitionAnimation,
    );
  }
}
