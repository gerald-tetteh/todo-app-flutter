import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utils/constants.dart';
import '../utils/color_utils.dart';
import '../models/todo_folder.dart';

import './folder_list_item.dart';

class FolderList extends StatelessWidget {
  const FolderList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final folders = Hive.box<TodoFolder>(TODOS_FOLDER);
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton(
            onPressed: () {},
            child: const Text(
              "Edit",
              style: TextStyle(
                color: ColorUtils.lightGreen,
                fontWeight: FontWeight.w900,
                fontSize: 17,
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: folders.listenable(),
              builder: (context, Box<TodoFolder> box, _) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: constraints.maxWidth * 0.39,
                        childAspectRatio: 2.0,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 30,
                      ),
                      itemCount: box.values.length,
                      itemBuilder: (context, index) {
                        final todoFolder = box.values.elementAt(index);
                        final iconData =
                            IconDataSolid(todoFolder.iconDataCodePoint!);
                        return FolderListItem(
                          iconData: iconData,
                          todoFolder: todoFolder,
                          index: index,
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
