/*
 * Author: Gerald Addo-Tetteh
 * Todo App
 * Cupertino Picker Container
*/
import 'package:flutter/material.dart';

import '../utils/color_utils.dart';

class CupertinoPickerContainer extends StatelessWidget {
  const CupertinoPickerContainer({
    Key? key,
    required this.picker,
  }) : super(key: key);

  final Widget picker;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Container(
      height: mediaQuery.size.height * 0.4,
      width: double.infinity,
      color: ColorUtils.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Row(
              children: [
                const Spacer(),
                TextButton(
                  onPressed: Navigator.of(context).pop,
                  child: const Text(
                    "Done",
                    style: TextStyle(
                      color: ColorUtils.lightGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: picker,
          ),
        ],
      ),
    );
  }
}
