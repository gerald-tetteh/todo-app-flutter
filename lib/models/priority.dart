/*
 * Author: Gerald Addo-Tetteh
 * Todo App
 * Priority
*/

import 'package:hive_flutter/hive_flutter.dart';

part 'priority.g.dart';

@HiveType(typeId: 3)
enum Priority {
  @HiveField(0)
  high,

  @HiveField(1)
  medium,

  @HiveField(2)
  low,
}
