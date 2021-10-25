/*
 * Author: Gerald Addo-Tetteh
 * Todo App
 * Home Content
*/
import 'package:flutter/material.dart';

import '../pages/create_folder.dart';
import '../utils/color_utils.dart';

import './folder_list.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final themeData = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: mediaQuery.size.height * 0.55,
          width: mediaQuery.size.width * 0.75,
          padding: EdgeInsets.only(
            top: mediaQuery.viewPadding.top,
            left: 25,
            right: 25,
          ),
          child: LayoutBuilder(builder: (context, constraints) {
            return Container(
              margin: EdgeInsets.only(
                top: constraints.maxHeight * 0.13,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    child: Text(
                      "Hello Gerald!",
                      style: themeData.textTheme.headline1,
                    ),
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.04,
                  ),
                  Text(
                    "You have 3 tasks scheduled for today",
                    style: TextStyle(
                      color: ColorUtils.white,
                      fontSize: constraints.maxWidth * 0.08,
                    ),
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.19,
                  ),
                  Hero(
                    tag: "create_folder",
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context)
                          .pushNamed(CreateFolder.routeName),
                      style: ElevatedButton.styleFrom(
                        primary: ColorUtils.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 25,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Create new folder",
                        style: TextStyle(
                          color: ColorUtils.blueGrey,
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
        Container(
          height: mediaQuery.size.height * 0.45,
          padding: EdgeInsets.only(
            bottom: mediaQuery.viewPadding.bottom,
            left: 25,
            right: 25,
          ),
          child: const FolderList(),
        ),
      ],
    );
  }
}
