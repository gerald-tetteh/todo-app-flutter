import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../pages/folder_view.dart';
import '../models/todo_folder.dart';
import '../utils/color_utils.dart';

class FolderListItem extends StatelessWidget {
  const FolderListItem({
    Key? key,
    required this.iconData,
    required this.todoFolder,
    required this.index,
  }) : super(key: key);

  final IconDataSolid iconData;
  final TodoFolder todoFolder;
  final int index;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        FolderView.routeName,
        arguments: {
          "folder": todoFolder,
          "index": index,
        },
      ),
      child: Hero(
        tag: todoFolder.name!,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
          semanticContainer: false,
          shadowColor: ColorUtils.blueGrey,
          child: Padding(
            padding: const EdgeInsets.all(17),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FaIcon(
                      iconData,
                      color: Color(todoFolder.iconColorValue!),
                    ),
                    Text(
                      "${todoFolder.todos?.length ?? 0}",
                      style: const TextStyle(
                        color: ColorUtils.blueGrey,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Text(
                  "${todoFolder.name}",
                  style: const TextStyle(
                    color: ColorUtils.black,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
