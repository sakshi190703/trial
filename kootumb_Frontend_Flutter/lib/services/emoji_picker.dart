import 'package:Kootumb/widgets/emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';

class EmojiPickerService {
  Future<void> pickEmoji(
      {required BuildContext context, required OnEmojiPicked onEmojiPicked}) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return FractionallySizedBox(
            heightFactor: 50,
            widthFactor: 100,
            child: SizedBox(
              child: OBEmojiPicker(
                onEmojiPicked: onEmojiPicked,
              ),
            ),
          );
        });
  }
}
