/*
 * Author: Gerald Addo-Tetteh
 * Todo App
 * Create folder
*/
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../utils/constants.dart';
import '../models/todo_folder.dart';
import '../widgets/backgound_stack_with_anim.dart';
import '../utils/color_utils.dart';
import '../widgets/gradient_button.dart';
import '../widgets/snackbar.dart';
import '../widgets/scaffold_boiler_plate.dart';

class CreateFolder extends StatefulWidget {
  const CreateFolder({
    Key? key,
    required this.transitionAnimation,
  }) : super(key: key);

  static const routeName = "/create-folder";
  final Animation<double> transitionAnimation;

  @override
  State<CreateFolder> createState() => _CreateFolderState();
}

class _CreateFolderState extends State<CreateFolder> {
  var _selectedColor = ColorUtils.lightGreen;
  var _selectedIcon = FontAwesomeIcons.folderOpen;
  var _folderName = "";
  var _isLoading = false;

  TextEditingController? _nameController;
  Box<TodoFolder>? _todoFolders;

  final _formKey = GlobalKey<FormState>();

  // show modal pickers
  Future<bool> showColorPickerDialog() async {
    return ColorPicker(
      onColorChanged: (color) => setState(() => _selectedColor = color),
      color: _selectedColor,
      width: 40,
      height: 40,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      heading: const Text("Select a Color"),
      subheading: const Text("Select a Color Shade"),
      showColorName: true,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: true,
        ColorPickerType.bw: false,
        ColorPickerType.custom: false,
        ColorPickerType.wheel: false,
      },
    ).showPickerDialog(context);
  }

  Future<void> showIconPickerDialog() async {
    final icon = await FlutterIconPicker.showIconPicker(
      context,
      iconPackMode: IconPack.fontAwesomeIcons,
      adaptiveDialog: true,
      constraints: const BoxConstraints(
        maxWidth: 390,
        maxHeight: 550,
      ),
    );
    if (icon != null) {
      setState(() => _selectedIcon = icon);
    }
  }

  Future<void> submit() async {
    setState(() => _isLoading = true);
    if (!_formKey.currentState!.validate()) {
      setState(() => _isLoading = false);
      return;
    }
    _formKey.currentState!.save();
    try {
      final folder = TodoFolder(
        name: _folderName,
        iconColorValue: _selectedColor.value,
        iconDataCodePoint: _selectedIcon.codePoint,
      );
      await _todoFolders?.add(folder);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: SnackbarContent(text: "Could not create folder"),
        ),
      );
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _folderName);
    _todoFolders = Hive.box<TodoFolder>(TODOS_FOLDER);
  }

  @override
  void dispose() {
    _nameController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BackgroundStackWithAnim(
      transitionAnimation: widget.transitionAnimation,
      content: ScaffoldBoilerPlate(
        transitionAnimation: widget.transitionAnimation,
        tag: CREATE_FOLDER,
        content: SingleChildScrollView(
          child: Material(
            type: MaterialType.transparency,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    child: TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: ColorUtils.blueGrey,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: ColorUtils.blueGrey,
                          ),
                        ),
                        hintText: "Folder Name",
                        labelText: "Folder Name",
                      ),
                      validator: (name) {
                        if (name!.isEmpty) {
                          return "Please enter a folder name";
                        }
                        try {
                          _todoFolders?.values.firstWhere((folder) =>
                              folder.name?.toLowerCase() == name.toLowerCase());
                        } catch (error) {
                          return null;
                        }
                        return "Folder name already exits";
                      },
                      onSaved: (name) => _folderName = name!,
                    ),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.only(
                      top: 20,
                      left: 16,
                      right: 16,
                    ),
                    onTap: showIconPickerDialog,
                    title: Text(
                      "Folder Icon",
                      style: theme.textTheme.headline2,
                    ),
                    trailing: FaIcon(
                      _selectedIcon,
                      color: _selectedColor,
                    ),
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.only(
                      top: 10,
                      left: 16,
                      right: 16,
                    ),
                    onTap: showColorPickerDialog,
                    title: Text(
                      "Icon Colour",
                      style: theme.textTheme.headline2,
                    ),
                    subtitle: Text(
                      ColorTools.nameThatColor(_selectedColor),
                    ),
                    trailing: Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        color: _selectedColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  GradientButton(
                    submit: submit,
                    text: "Create",
                    isLoading: _isLoading,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
