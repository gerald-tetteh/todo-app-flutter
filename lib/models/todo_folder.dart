/*
 * Author: Gerald Addo-Tetteh
 * Todo App
 * Todo Folder Model
*/
import 'package:hive/hive.dart';

import './todo.dart';

part 'todo_folder.g.dart';

@HiveType(typeId: 1)
class TodoFolder extends HiveObject {
  @HiveField(1)
  final String? name;
  @HiveField(2)
  HiveList<Todo>? todos;
  @HiveField(3)
  final int? iconDataCodePoint;
  @HiveField(5)
  final int? iconColorValue;

  TodoFolder({
    this.iconDataCodePoint,
    this.name,
    this.todos,
    this.iconColorValue,
  });
}
