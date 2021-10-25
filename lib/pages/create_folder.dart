/*
 * Author: Gerald Addo-Tetteh
 * Todo App
 * Create folder
*/
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/backgound_stack_with_anim.dart';
import '../utils/color_utils.dart';

class CreateFolder extends StatefulWidget {
  CreateFolder({
    Key? key,
    required this.transitionAnimation,
  }) : super(key: key);

  static const routeName = "/create-folder";
  final Animation<double> transitionAnimation;

  @override
  State<CreateFolder> createState() => _CreateFolderState();
}

class _CreateFolderState extends State<CreateFolder> {
  final headingTween = Tween<Offset>(
    begin: const Offset(-1, 0),
    end: const Offset(0, 0),
  );

  var _selectedColor = ColorUtils.blueGrey;
  var _selectedIcon = FontAwesomeIcons.folderOpen;
  var _folderName = "";

  TextEditingController? nameController;

  Future<bool> showColorPickerDialog() async {
    return ColorPicker(
      onColorChanged: (color) {},
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
              headingTween: headingTween,
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
                                  border: UnderlineInputBorder(),
                                  label: Text("Folder Name"),
                                ),
                              ),
                            ),
                            ListTile(
                              title: const Text("Icon"),
                              trailing: FaIcon(_selectedIcon),
                            ),
                            ListTile(
                              onTap: showColorPickerDialog,
                              title: const Text("Icon colour"),
                              trailing: Container(
                                height: 50,
                                width: 50,
                                color: _selectedColor,
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
          ],
        ),
      ),
    );
  }
}

class AnimatedHeadingText extends StatelessWidget {
  const AnimatedHeadingText({
    Key? key,
    required this.transitionAnimation,
    required this.headingTween,
    required this.theme,
  }) : super(key: key);

  final Animation<double> transitionAnimation;
  final Tween<Offset> headingTween;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: transitionAnimation,
      builder: (context, child) {
        return SlideTransition(
          position: transitionAnimation.drive(headingTween),
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
