/*
 * Author: Gerald Addo-Tetteh
 * Todo App
 * Create Todo
*/
import 'package:flutter/material.dart';
import 'package:todo_app/widgets/scaffold_boiler_plate.dart';
import '../widgets/background_with_stack_no_anim.dart';

class CreateTodo extends StatelessWidget {
  const CreateTodo({
    Key? key,
    required this.transitionAnimation,
  }) : super(key: key);

  final Animation<double> transitionAnimation;
  static const routeName = "/create-todo";

  @override
  Widget build(BuildContext context) {
    return BackgroundStackNoAnim(
      scale: 2,
      content: ScaffoldBoilerPlate(
        content: const Text("hello"),
        transitionAnimation: transitionAnimation,
        tag: "",
        title: "New To do",
      ),
    );
  }
}
