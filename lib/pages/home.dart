/*
 * Author: Gerald Addo-Tetteh
 * Todo App
*/
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

import '../widgets/background_with_stack_no_anim.dart';
import '../widgets/home_content.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: BackgroundStackNoAnim(
        content: HomeContent(),
      ),
    );
  }
}
