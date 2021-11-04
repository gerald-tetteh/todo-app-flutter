/*
 * Author: Gerald Addo-Tetteh
 * Todo App
 * Display Todos Boiler Plate
*/
import 'package:flutter/material.dart';

import './list_divider.dart';

class DisplayTodosBoilerPlate extends StatelessWidget {
  const DisplayTodosBoilerPlate({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        children: [
          const ListDivider(),
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}
