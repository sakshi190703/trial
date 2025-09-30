import 'package:Kootumb/models/emoji_group.dart';
import 'package:Kootumb/widgets/emoji_picker/widgets/emoji_groups/widgets/emoji_group/emoji_group.dart';
import 'package:Kootumb/widgets/emoji_picker/widgets/emoji_groups/widgets/emoji_group/widgets/emoji.dart';
import 'package:flutter/material.dart';

class OBEmojiGroups extends StatelessWidget {
  final OnEmojiPressed? onEmojiPressed;
  final List<EmojiGroup> emojiGroups;

  const OBEmojiGroups(this.emojiGroups, {Key? key, this.onEmojiPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: emojiGroups.length,
        itemBuilder: (BuildContext context, index) {
          EmojiGroup emojiGroup = emojiGroups[index];
          return OBEmojiGroup(
            emojiGroup,
            onEmojiPressed: onEmojiPressed,
          );
        });
  }
}
