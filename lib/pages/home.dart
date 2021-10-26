/*
 * Author: Gerald Addo-Tetteh
 * Todo App
*/
import 'package:flutter/material.dart';

import '../widgets/background_with_stack_no_anim.dart';
import '../widgets/home_content.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: BackgroundStackNoAnim(
        content: HomeContent(),
      ),
    );
  }
}
