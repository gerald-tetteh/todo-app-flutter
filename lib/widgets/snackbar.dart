/*
 * Author: Gerald Addo-Tetteh
 * Todo App
 * Gradient Button
*/
import 'package:flutter/material.dart';

class SnackbarContent extends StatelessWidget {
  const SnackbarContent({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: theme.textTheme.bodyText1,
    );
  }
}
