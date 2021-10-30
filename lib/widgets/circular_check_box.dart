/*
 * Author: Gerald Addo-Tetteh
 * Todo App
 * Circular Check Box
*/
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utils/color_utils.dart';

class CircularCheckBox extends StatelessWidget {
  const CircularCheckBox({
    Key? key,
    required this.value,
    required this.onTap,
  }) : super(key: key);

  final bool value;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: !value
              ? Border.all(
                  color: ColorUtils.blueGreyAlpha80,
                  width: 1.9,
                )
              : null,
        ),
        width: 27,
        height: 27,
        child: Opacity(
          opacity: value ? 1 : 0,
          child: Container(
            height: 27,
            width: 27,
            decoration: const BoxDecoration(
              color: ColorUtils.lightGreen,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.check,
                color: ColorUtils.white,
                size: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
