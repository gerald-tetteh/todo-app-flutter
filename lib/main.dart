import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

import './models/priority.dart';
import './pages/create_todo.dart';
import './pages/folder_view.dart';
import './pages/create_folder.dart';
import './pages/home.dart';
import './utils/color_utils.dart';
import './models/todo.dart';
import './models/todo_folder.dart';
import './utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // intialize database and adapters
  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());
  Hive.registerAdapter(TodoFolderAdapter());
  Hive.registerAdapter(PriorityAdapter());
  final folders = await Hive.openBox<TodoFolder>(TODOS_FOLDER);
  final todos = await Hive.openBox<Todo>(TODOS);
  // add default folder; all for every instance of the app
  if (folders.isEmpty) {
    final allTodosFolder = TodoFolder(
      name: "All",
      iconDataCodePoint: FontAwesomeIcons.fileAlt.codePoint,
      todos: HiveList<Todo>(todos),
      iconColorValue: const Color(0xffda6970).value,
    );
    final workTodosFolder = TodoFolder(
      name: "Work",
      iconDataCodePoint: FontAwesomeIcons.folderOpen.codePoint,
      iconColorValue: const Color(0xff52b2ae).value,
    );
    try {
      await folders.put(ALL_TODOS_KEY, allTodosFolder);
      await folders.add(workTodosFolder);
    } catch (e) {}
  }
  AwesomeNotifications().initialize(
    "resource://drawable/res_notification_icon",
    [
      NotificationChannel(
        channelKey: SCHEDULE_TODO,
        channelName: "TO DO Notifications",
        defaultColor: ColorUtils.blueGrey,
        importance: NotificationImportance.High,
        channelShowBadge: true,
        ledColor: ColorUtils.lightGreenDark,
      ),
    ],
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blueGrey,
          accentColor: Colors.green[600],
          backgroundColor: Colors.white,
        ),
        fontFamily: "Roboto",
        textTheme: TextTheme(
          headline1: const TextStyle(
            color: ColorUtils.white,
            fontSize: 40,
            fontWeight: FontWeight.w500,
          ),
          headline2: const TextStyle(
            color: ColorUtils.blueGrey,
            fontWeight: FontWeight.w500,
            fontSize: 17,
          ),
          headline3: const TextStyle(
            color: ColorUtils.blueGrey,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
          bodyText1: TextStyle(
            color: Colors.black.withAlpha(170),
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
          bodyText2: TextStyle(
            color: Colors.black.withAlpha(170),
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
          caption: TextStyle(
            color: ColorUtils.blueGrey.withAlpha(120),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          button: const TextStyle(
            color: ColorUtils.white,
            fontSize: 17,
          ),
        ),
      ),
      home: const Home(),
      onGenerateRoute: (settings) {
        if (settings.name == FolderView.routeName) {
          return PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 300),
            pageBuilder: (context, animation, secondaryAnimation) {
              final arguments = settings.arguments as Map<String, dynamic>;
              return FolderView(
                transitionAnimation: animation,
                todoFolder: arguments["folder"] as TodoFolder,
                index: arguments["index"] as int,
              );
            },
          );
        } else if (settings.name == CreateFolder.routeName) {
          return PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 300),
            pageBuilder: (context, animation, secondaryAnimation) {
              return CreateFolder(
                transitionAnimation: animation,
              );
            },
          );
        } else if (settings.name == CreateTodo.routeName) {
          return PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 700),
            pageBuilder: (context, animation, secondaryAnimation) {
              return CreateTodo(
                transitionAnimation: animation,
                folderKey: settings.arguments,
              );
            },
          );
        }
      },
    );
  }
}
