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
  }) : super(key: key);

  final IconDataSolid iconData;
  final TodoFolder todoFolder;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        FolderView.routeName,
        arguments: todoFolder.name,
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
                const Spacer(),
                Text(
                  "${todoFolder.name}",
                  style: const TextStyle(
                    color: ColorUtils.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
