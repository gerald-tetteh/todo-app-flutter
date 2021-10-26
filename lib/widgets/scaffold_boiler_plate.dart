/*
 * Author: Gerald Addo-Tetteh
 * Todo App
 * ScaffoldBoilerPlate
*/
import 'package:flutter/material.dart';

import '../utils/color_utils.dart';

import './animated_header_text.dart';

class ScaffoldBoilerPlate extends StatelessWidget {
  const ScaffoldBoilerPlate({
    Key? key,
    required this.content,
    required this.transitionAnimation,
    required this.tag,
  }) : super(key: key);

  final Animation<double> transitionAnimation;
  final Widget content;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedHeadingText(
            transitionAnimation: transitionAnimation,
            title: "New Folder",
          ),
          Expanded(
            child: Hero(
              tag: tag,
              child: Container(
                padding: const EdgeInsets.only(
                  top: 25,
                  left: 10,
                  right: 10,
                ),
                clipBehavior: Clip.antiAlias,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: ColorUtils.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: content,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
