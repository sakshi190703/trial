import 'package:Kootumb/models/emoji.dart';
import 'package:Kootumb/models/emoji_group.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

enum OBEmojiSize { small, medium, large }

class OBEmoji extends StatelessWidget {
  final Emoji emoji;
  final EmojiGroup? emojiGroup;
  final OnEmojiPressed? onEmojiPressed;
  final OBEmojiSize size;

  const OBEmoji(this.emoji,
      {Key? key,
      this.onEmojiPressed,
      this.emojiGroup,
      this.size = OBEmojiSize.medium})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double dimensions = getIconDimensions(size);

    return IconButton(
        icon: CachedNetworkImage(
          height: dimensions,
          width: dimensions,
          imageUrl: emoji.image ?? '',
          placeholder: (context, url) => SizedBox(
            height: dimensions,
            width: dimensions,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          errorWidget: (context, url, error) =>
              Icon(Icons.error, size: dimensions),
        ),
        onPressed: onEmojiPressed != null
            ? () {
                onEmojiPressed!(emoji);
              }
            : null);
  }

  double getIconDimensions(OBEmojiSize size) {
    late double iconSize;

    switch (size) {
      case OBEmojiSize.large:
        iconSize = 45;
        break;
      case OBEmojiSize.medium:
        iconSize = 25;
        break;
      case OBEmojiSize.small:
        iconSize = 15;
        break;
      default:
    }

    return iconSize;
  }
}

typedef OnEmojiPressed = void Function(Emoji emoji);
