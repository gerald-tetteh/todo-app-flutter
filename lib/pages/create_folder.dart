/*
 * Author: Gerald Addo-Tetteh
 * Todo App
 * Create folder
*/
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/backgound_stack_with_anim.dart';
import '../utils/color_utils.dart';

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

  TextEditingController? nameController;

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
    );
    if (icon != null) {
      setState(() => _selectedIcon = icon);
    }
  }

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: _folderName);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BackgroundStackWithAnim(
      transitionAnimation: widget.transitionAnimation,
      content: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedHeadingText(
              transitionAnimation: widget.transitionAnimation,
              theme: theme,
            ),
            Expanded(
              child: Hero(
                tag: "create_folder",
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 25,
                    left: 10,
                    right: 10,
                  ),
                  clipBehavior: Clip.antiAlias,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: ColorUtils.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Material(
                      type: MaterialType.transparency,
                      child: Form(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              child: TextFormField(
                                controller: nameController,
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
                                ),
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
                              trailing: FaIcon(_selectedIcon),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(
                            //     horizontal: 15,
                            //   ),
                            //   child: Divider(
                            //     height: 0,
                            //     thickness: 1,
                            //     color: ColorUtils.blueGrey.withAlpha(150),
                            //   ),
                            // ),
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
                            ElevatedButton(
                              onPressed: () {},
                              child: Text("hello"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedHeadingText extends StatelessWidget {
  AnimatedHeadingText({
    Key? key,
    required this.transitionAnimation,
    required this.theme,
  }) : super(key: key);

  final Animation<double> transitionAnimation;
  final ThemeData theme;

  final headingTween = Tween<double>(
    begin: 0,
    end: 1,
  );

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: transitionAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: transitionAnimation.drive(headingTween),
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          bottom: 15,
          top: 20,
        ),
        child: Text(
          "New Folder",
          style: theme.textTheme.headline1,
        ),
      ),
    );
  }
}
