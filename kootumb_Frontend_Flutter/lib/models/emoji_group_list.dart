import 'package:Kootumb/models/emoji_group.dart';

class EmojiGroupList {
  final List<EmojiGroup>? emojisGroups;

  EmojiGroupList({
    this.emojisGroups,
  });

  factory EmojiGroupList.fromJson(List<dynamic> parsedJson) {
    List<EmojiGroup> emojiGroups =
        parsedJson.map((emojiJson) => EmojiGroup.fromJson(emojiJson)).toList();

    return EmojiGroupList(
      emojisGroups: emojiGroups,
    );
  }
}
