/*
 * Author: Gerald Addo-Tetteh
 * Todo App
 * Animated Heading Text
*/
import 'package:flutter/material.dart';

class AnimatedHeadingText extends StatelessWidget {
  AnimatedHeadingText({
    Key? key,
    required this.transitionAnimation,
    required this.title,
  }) : super(key: key);

  final Animation<double> transitionAnimation;
  final String title;

  final headingTween = Tween<double>(
    begin: 0,
    end: 1,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: transitionAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: transitionAnimation.drive(headingTween),
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          bottom: 15,
          top: 20,
        ),
        child: Text(
          title,
          style: theme.textTheme.headline1,
        ),
      ),
    );
  }
}
