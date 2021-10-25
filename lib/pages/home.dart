/*
 * Author: Gerald Addo-Tetteh
 * Todo App
*/
import 'package:flutter/material.dart';

import '../utils/color_utils.dart';
import '../widgets/home_content.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.hardEdge,
        children: [
          SizedBox(
            width: mediaQuery.size.width,
            height: mediaQuery.size.height,
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
            child: Container(
              decoration: const BoxDecoration(
                color: ColorUtils.blueGrey,
                shape: BoxShape.circle,
              ),
              width: mediaQuery.size.width * 1.17,
              height: mediaQuery.size.height,
            ),
          ),
          const HomeContent(),
        ],
      ),
    );
  }
}
