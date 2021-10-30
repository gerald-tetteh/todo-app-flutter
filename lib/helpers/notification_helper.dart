/*
 * Author: Gerald Addo-Tetteh
 * Todo App
 * Notification Helper
*/

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';

class NotificationHelper {
  static int generateId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }

  static Future<int> createNotification(
    TimeOfDay alarmTime,
    DateTime alarmDate,
    String title, {
    String? imagePath,
  }) async {
    final notificationId = NotificationHelper.generateId();
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        icon: "resource://drawable/res_notification_icon",
        id: notificationId,
        channelKey: SCHEDULE_TODO,
        title: "One of your tasks is due !",
        body: title,
        bigPicture: "file://$imagePath",
        notificationLayout: imagePath != null
            ? NotificationLayout.BigPicture
            : NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        repeats: false,
        weekday: alarmDate.weekday,
        hour: alarmTime.hour,
        minute: alarmTime.minute,
        second: 0,
        millisecond: 0,
        month: alarmDate.month,
        year: alarmDate.year,
        day: alarmDate.day,
      ),
    );
    return notificationId;
  }

  static Future<void> cancelTodoNotification(int scheduleId) async {
    await AwesomeNotifications().cancelSchedule(scheduleId);
  }
}
