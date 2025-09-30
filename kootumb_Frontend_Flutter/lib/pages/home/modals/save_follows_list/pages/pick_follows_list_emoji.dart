import 'package:Kootumb/models/emoji.dart';
import 'package:Kootumb/models/emoji_group.dart';
import 'package:Kootumb/widgets/emoji_picker/emoji_picker.dart';
import 'package:Kootumb/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Kootumb/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';

class OBPickFollowsListEmojiPage extends StatelessWidget {
  const OBPickFollowsListEmojiPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: 'Pick emoji',
      ),
      child: OBPrimaryColorContainer(
        child: OBEmojiPicker(
          onEmojiPicked: (Emoji? pickedEmoji, EmojiGroup? emojiGroup) {
            Navigator.pop(context, pickedEmoji);
          },
        ),
      ),
    );
  }
}
