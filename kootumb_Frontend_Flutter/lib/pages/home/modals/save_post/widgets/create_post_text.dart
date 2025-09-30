import 'package:Kootumb/widgets/fields/text_field.dart';
import 'package:flutter/material.dart';

class OBCreatePostText extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;

  const OBCreatePostText(
      {Key? key, this.controller, this.focusNode, this.hintText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OBTextField(
      textInputAction: TextInputAction.newline,
      controller: controller,
      autofocus: true,
      focusNode: focusNode,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      style: TextStyle(fontSize: 18),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hintText ?? 'What\'s going on?',
      ),
      autocorrect: true,
    );
  }
}
