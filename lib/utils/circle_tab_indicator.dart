/*
 * Author: Gerald Addo-Tetteh
 * Todo App
 * All Todos
*/

import 'package:flutter/material.dart';

class CircleIndicator extends Decoration {
  final Color color;
  final double radius;

  const CircleIndicator({required this.color, required this.radius});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CircleIndicatorPainter(color, radius, onChanged);
  }
}

class _CircleIndicatorPainter extends BoxPainter {
  final Paint _paint;
  final double radius;

  _CircleIndicatorPainter(Color color, this.radius, VoidCallback? onChanged)
      : _paint = Paint()
          ..color = color
          ..isAntiAlias = true,
        super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    // paints circle benath tab text
    final circleOffset =
        offset + Offset(cfg.size!.width / 2, cfg.size!.height + 10);
    canvas.drawCircle(circleOffset, radius, _paint);
  }
}
