/*
 * Author: Gerald Addo-Tetteh
 * Todo App
 * Create Todo
*/
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/todo.dart';
import '../utils/color_utils.dart';
import '../models/todo_folder.dart';
import '../utils/constants.dart';
import '../widgets/scaffold_boiler_plate.dart';
import '../widgets/background_with_stack_no_anim.dart';
import '../widgets/text_field_form.dart';

class CreateTodo extends StatefulWidget {
  const CreateTodo({
    Key? key,
    required this.transitionAnimation,
    required this.folderKey,
  }) : super(key: key);

  final Animation<double> transitionAnimation;
  final dynamic folderKey;
  static const routeName = "/create-todo";

  @override
  State<CreateTodo> createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {
  late final List<DropdownMenuItem> _foldersDropDownItems;
  late dynamic _dropDownValue;
  final _folders = Hive.box<TodoFolder>(TODOS_FOLDER);

  late final TextEditingController _titleController;
  late final TextEditingController _notesController;

  String imagePath = "";
  TimeOfDay? _alarmTimeOfDay;
  DateTime? _alarmDateTime;
  Priority _priority = Priority.low;
  bool _setAlarm = true;
  String _title = "";
  String _notes = "";

  void _buildFoldersDropDown() {
    _foldersDropDownItems = _folders.values.map<DropdownMenuItem>((folder) {
      return DropdownMenuItem(
        value: folder.key,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(
              IconDataSolid(folder.iconDataCodePoint!),
              color: Color(folder.iconColorValue!),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(folder.name!),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _buildFoldersDropDown();
    _dropDownValue = widget.folderKey;

    _titleController = TextEditingController(text: _title);
    _notesController = TextEditingController(text: _notes);
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundStackNoAnim(
      scale: 2,
      content: ScaffoldBoilerPlate(
        transitionAnimation: widget.transitionAnimation,
        tag: "",
        title: "New To do",
        content: Padding(
          padding: const EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
          ),
          child: ScaleTransition(
            scale: widget.transitionAnimation,
            child: Form(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButton<dynamic>(
                      onChanged: (folderKey) {
                        setState(() => _dropDownValue = folderKey);
                      },
                      iconSize: 15,
                      iconDisabledColor: ColorUtils.blueGrey.withAlpha(170),
                      items: _foldersDropDownItems,
                      value: _dropDownValue,
                      icon: const FaIcon(
                        FontAwesomeIcons.chevronDown,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    TextFieldForm(
                      hintAndLabelText: "Title",
                      textController: _titleController,
                      validator: (title) {
                        if (title!.isEmpty) {
                          return "Please enter a title";
                        }
                        return null;
                      },
                      onSaved: (title) => _title = title!,
                    ),
                    TextFieldForm(
                      hintAndLabelText: "Notes",
                      textController: _notesController,
                      validator: (notes) {
                        if (notes!.isEmpty) {
                          return "Please some notes";
                        }
                        return null;
                      },
                      onSaved: (notes) => _notes = notes!,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
