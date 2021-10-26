/*
 * Author: Gerald Addo-Tetteh
 * Todo App
 * List Divider
*/

import 'package:flutter/material.dart';

import '../utils/color_utils.dart';

class ListDivider extends StatelessWidget {
  const ListDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: 1.3,
      color: ColorUtils.blueGreyAlpha80,
    );
  }
}
