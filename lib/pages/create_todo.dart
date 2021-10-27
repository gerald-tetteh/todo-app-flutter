/*
 * Author: Gerald Addo-Tetteh
 * Todo App
 * Create Todo
*/
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/widgets/gradient_button.dart';

import '../widgets/list_divider.dart';
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
  String _formtedDate = "Day, dd,mm,yy 0:00AM";

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

  Future<void> showDateAndTimePicker() async {
    final now = DateTime.now();
    if (Platform.isIOS) {
      await showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return CupertinoPickerContainer(
            picker: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: now,
              minimumDate: now,
              maximumDate: DateTime(now.year + 10),
              onDateTimeChanged: (date) => _alarmDateTime = date,
            ),
          );
        },
      );
      if (_alarmDateTime != null) {
        await showCupertinoModalPopup(
          context: context,
          builder: (context) {
            return CupertinoPickerContainer(
              picker: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: now,
                minimumDate: now,
                maximumDate: DateTime(now.year + 10),
                onDateTimeChanged: (date) =>
                    _alarmTimeOfDay = TimeOfDay.fromDateTime(date),
              ),
            );
          },
        );
      }
    } else {
      _alarmDateTime = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: now,
        lastDate: DateTime(now.year + 10),
      );
      if (_alarmDateTime != null) {
        _alarmTimeOfDay = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(now),
          builder: (context, child) {
            return child!;
          },
        );
      }
    }
    _buildDateString();
  }

  void _buildDateString() {
    if (_alarmTimeOfDay != null && _alarmDateTime != null) {
      final dateToFormate = DateTime(
        _alarmDateTime!.year,
        _alarmDateTime!.month,
        _alarmDateTime!.day,
        _alarmTimeOfDay!.hour,
        _alarmTimeOfDay!.minute,
      );
      setState(() {
        _formtedDate = DateFormat.yMEd().add_jm().format(dateToFormate);
      });
    }
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
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                      underline: const SizedBox(),
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
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      value: _setAlarm,
                      onChanged: (value) => setState(() => _setAlarm = value),
                      activeColor: ColorUtils.lightGreen,
                      title: Text(
                        "Set Date",
                        style: theme.textTheme.headline2,
                      ),
                    ),
                    ListTile(
                      onTap: showDateAndTimePicker,
                      contentPadding: EdgeInsets.zero,
                      title: const Text("Alarm"),
                      trailing: Text(_formtedDate),
                    ),
                    const ListDivider(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text("Priority"),
                      trailing: FaIcon(
                        FontAwesomeIcons.chevronRight,
                        size: 15,
                        color: ColorUtils.blueGrey.withAlpha(180),
                      ),
                    ),
                    const ListDivider(),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Row(
                        children: const [
                          FaIcon(
                            FontAwesomeIcons.plus,
                            size: 15,
                            color: ColorUtils.lightGreen,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text("Add Image"),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 50,
                        bottom: 10,
                      ),
                      child: Center(
                        child: GradientButton(
                          submit: () async {},
                          text: "Create",
                        ),
                      ),
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

class CupertinoPickerContainer extends StatelessWidget {
  const CupertinoPickerContainer({
    Key? key,
    required this.picker,
  }) : super(key: key);

  final Widget picker;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Container(
      height: mediaQuery.size.height * 0.4,
      width: double.infinity,
      color: ColorUtils.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Row(
              children: [
                const Spacer(),
                TextButton(
                  onPressed: Navigator.of(context).pop,
                  child: const Text(
                    "Done",
                    style: TextStyle(
                      color: ColorUtils.lightGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: picker,
          ),
        ],
      ),
    );
  }
}
