/*
 * Author: Gerald Addo-Tetteh
 * Todo App
 * Helper Functions
*/
import 'package:intl/intl.dart';

import '../models/todo.dart';

String getTodayText(int year, int month, int day) {
  final currentDay = DateTime(year, month, day);
  switch (currentDay.weekday) {
    case DateTime.monday:
      return "Monday";
    case DateTime.tuesday:
      return "Tuesday";
    case DateTime.wednesday:
      return "Wednesday";
    case DateTime.thursday:
      return "Thursday";
    case DateTime.friday:
      return "Friday";
    case DateTime.saturday:
      return "Saturday";
    case DateTime.sunday:
      return "Sunday";
    default:
      return "";
  }
}

String getMonthText(int month) {
  switch (month) {
    case DateTime.january:
      return "January";
    case DateTime.february:
      return "February";
    case DateTime.march:
      return "March";
    case DateTime.april:
      return "April";
    case DateTime.may:
      return "May";
    case DateTime.june:
      return "June";
    case DateTime.july:
      return "July";
    case DateTime.august:
      return "August";
    case DateTime.september:
      return "September";
    case DateTime.october:
      return "October";
    case DateTime.november:
      return "November";
    case DateTime.december:
      return "December";
    default:
      return "";
  }
}

String buildTimeString(Todo todo) {
  return DateFormat.jm().format(todo.alarmDateTime!);
}
