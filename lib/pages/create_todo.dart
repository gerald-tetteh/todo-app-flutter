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
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import '../widgets/snackbar.dart';
import '../widgets/gradient_button.dart';
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

  TimeOfDay? _alarmTimeOfDay;
  DateTime? _alarmDateTime;
  Priority _priority = Priority.low;
  bool _setAlarm = true;
  String _title = "";
  String _notes = "";
  String _formtedDate = "Click to set";
  File? _image;
  bool isCameraImage = false;
  bool isSaved = false;

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

  Color _getPriorityColor() {
    switch (_priority) {
      case Priority.low:
        return ColorUtils.lightGreen;
      case Priority.medium:
        return Colors.amber;
      case Priority.high:
        return Colors.red;
      default:
        return Colors.green;
    }
  }

  // shows a pop up menu to select
  // the priority of the todo (IOS)
  Future<void> _showPriorityPopUp() async {
    final result = await showCupertinoModalPopup<Priority?>(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop(Priority.low),
            child: const Text("Low Priority"),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop(Priority.medium),
            child: const Text("Medium Priority"),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop(Priority.high),
            child: const Text("High Priority"),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: Navigator.of(context).pop,
          child: const Text("Cancel"),
        ),
      ),
    );
    if (result != null) {
      setState(() => _priority = result);
    }
  }

  Future<ImageSource?> _showImagePickerSourceDialog() async {
    if (Platform.isIOS) {
      return showCupertinoDialog<ImageSource>(
        barrierDismissible: true,
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text("Pick Image"),
          content: const Text("Do you want to open the camera of gallary ?"),
          actions: [
            CupertinoDialogAction(
              child: const Text('Camera'),
              onPressed: () => Navigator.of(context).pop(ImageSource.camera),
            ),
            CupertinoDialogAction(
              child: const Text('Gallery'),
              onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
            ),
          ],
        ),
      );
    } else {
      return showDialog<ImageSource>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Pick Image"),
          content: const Text("Do you want to open the camera of gallary ?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(ImageSource.camera),
              child: const Text('Camera'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(ImageSource.gallery),
              child: const Text('Gallery'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final imageSource = await _showImagePickerSourceDialog();
    if (imageSource != null) {
      try {
        final pickedImage = await imagePicker.pickImage(source: imageSource);
        if (pickedImage != null) {
          if (imageSource == ImageSource.camera) {
            final baseName = path.basename(pickedImage.path);
            final pickedImageFile = File(pickedImage.path);
            final appDirectory = await getApplicationDocumentsDirectory();
            final savedImageFile = await pickedImageFile
                .copy(path.join(appDirectory.path, baseName));
            if (_image != null && isCameraImage) {
              await _image?.delete();
              _image = null;
            }
            isCameraImage = true;
            setState(() => _image = savedImageFile);
          } else {
            if (_image != null && isCameraImage) {
              await _image?.delete();
              _image = null;
            }
            isCameraImage = false;
            setState(() => _image = File(pickedImage.path));
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: SnackbarContent(text: "Could read or save Image"),
          ),
        );
      }
    }
  }

  Future<bool> _willPop() async {
    bool result = true;
    if (!isSaved) {
      if (Platform.isIOS) {
        await showCupertinoDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) => CupertinoAlertDialog(
            title: const Text("Exit without saving ?"),
            content: const Text("Do you want to exit without saving ?"),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  result = true;
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Exit",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  result = false;
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
            ],
          ),
        );
      } else {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text("Exit without saving ?"),
            content: const Text("Do you want to exit without saving ?"),
            actions: [
              TextButton(
                onPressed: () {
                  result = true;
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Exit",
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () {
                  result = false;
                  Navigator.of(context).pop();
                },
                child: const Text("Cancel"),
              ),
            ],
          ),
        );
      }
    }
    if (result && isCameraImage) {
      await _image?.delete();
    }
    return result;
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
      content: WillPopScope(
        onWillPop: _willPop,
        child: ScaffoldBoilerPlate(
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
                      if (Platform.isAndroid) _buildPopupPriorityMenu(),
                      if (Platform.isIOS) _buildPriorityTile(),
                      const ListDivider(),
                      Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: GestureDetector(
                          onTap: _pickImage,
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
                      ),
                      Center(
                        child: AnimatedCrossFade(
                          duration: const Duration(milliseconds: 700),
                          crossFadeState: _image == null
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          firstChild: const SizedBox(),
                          secondChild: Container(
                            margin: const EdgeInsets.only(top: 15),
                            height: 250,
                            width: 250,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              image: _image != null
                                  ? DecorationImage(
                                      image: FileImage(_image!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: _image == null ? 20 : 10,
                          bottom: 30,
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
      ),
    );
  }

  PopupMenuButton<Priority> _buildPopupPriorityMenu() {
    return PopupMenuButton<Priority>(
      initialValue: _priority,
      padding: EdgeInsets.zero,
      onSelected: (priority) => setState(() => _priority = priority),
      itemBuilder: (context) => <PopupMenuEntry<Priority>>[
        const PopupMenuItem(
          value: Priority.low,
          child: Text("Low"),
        ),
        const PopupMenuItem(
          value: Priority.medium,
          child: Text("Medium"),
        ),
        const PopupMenuItem(
          value: Priority.high,
          child: Text("High"),
        ),
      ],
      child: _buildPriorityTile(),
    );
  }

  ListTile _buildPriorityTile() {
    return ListTile(
      onTap: Platform.isIOS ? _showPriorityPopUp : null,
      contentPadding: EdgeInsets.zero,
      title: const Text("Priority"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(
            FontAwesomeIcons.infoCircle,
            color: _getPriorityColor(),
            size: 15,
          ),
          const SizedBox(
            width: 20,
          ),
          FaIcon(
            FontAwesomeIcons.chevronRight,
            size: 15,
            color: ColorUtils.blueGrey.withAlpha(180),
          ),
        ],
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
