/*
 * Author: Gerald Addo-Tetteh
 * Todo App
 * BackgrounStackWithAnim
*/
import 'package:flutter/material.dart';

import '../utils/color_utils.dart';

class BackgroundStackWithAnim extends StatelessWidget {
  const BackgroundStackWithAnim({
    Key? key,
    required this.transitionAnimation,
    this.content,
  }) : super(key: key);

  final Animation<double>? transitionAnimation;
  final Widget? content;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
        ),
        Positioned(
          top: -mediaQuery.size.height * 0.30,
          right: -mediaQuery.size.width * 0.8,
          child: Container(
            decoration: const BoxDecoration(
              color: ColorUtils.lightGreen,
              shape: BoxShape.circle,
            ),
            width: mediaQuery.size.width * 1.5,
            height: mediaQuery.size.height,
          ),
        ),
        Positioned(
          top: -mediaQuery.size.height * 0.30,
          left: -mediaQuery.size.width * 0.27,
          child: AnimatedBuilder(
            animation: transitionAnimation!,
            builder: (context, child) {
              return Transform.scale(
                scale: transitionAnimation!.value + 1,
                child: Container(
                  decoration: const BoxDecoration(
                    color: ColorUtils.blueGrey,
                    shape: BoxShape.circle,
                  ),
                  width: mediaQuery.size.width * 1.17,
                  height: mediaQuery.size.height,
                ),
              );
            },
          ),
        ),
        if (content != null) content!
      ],
    );
  }
}
