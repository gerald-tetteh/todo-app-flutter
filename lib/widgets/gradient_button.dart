/*
 * Author: Gerald Addo-Tetteh
 * Todo App
 * Gradient Button
*/
import 'package:flutter/material.dart';

import '../utils/color_utils.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({
    Key? key,
    required this.submit,
    required this.text,
    this.isLoading = false,
  }) : super(key: key);

  final Future<void> Function() submit;
  final String text;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: submit,
      style: ElevatedButton.styleFrom(
        primary: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        fixedSize: Size(
          mediaQuery.size.width * 0.8,
          40,
        ),
        padding: EdgeInsets.zero,
      ),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              ColorUtils.lightGreenDark,
              ColorUtils.lightGreenLight,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator.adaptive()
              : Text(
                  text,
                  style: theme.textTheme.button,
                ),
        ),
      ),
    );
  }
}
