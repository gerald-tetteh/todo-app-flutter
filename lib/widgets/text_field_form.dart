/*
 * Author: Gerald Addo-Tetteh
 * Todo App
 * Text Field Form
*/
import 'package:flutter/material.dart';

import '../utils/color_utils.dart';

class TextFieldForm extends StatelessWidget {
  const TextFieldForm({
    Key? key,
    required this.hintAndLabelText,
    required this.textController,
    required this.validator,
    required this.onSaved,
  }) : super(key: key);

  final TextEditingController textController;
  final String hintAndLabelText;
  final String? Function(String? value) validator;
  final void Function(String? value) onSaved;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      decoration: InputDecoration(
        border: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: ColorUtils.blueGrey,
          ),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: ColorUtils.blueGrey,
          ),
        ),
        hintText: hintAndLabelText,
        labelText: hintAndLabelText,
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }
}
