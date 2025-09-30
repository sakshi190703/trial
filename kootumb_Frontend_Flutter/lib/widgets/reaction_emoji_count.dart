import 'package:Kootumb/models/reactions_emoji_count.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'buttons/button.dart';

class OBEmojiReactionButton extends StatelessWidget {
  final ReactionsEmojiCount postReactionsEmojiCount;
  final bool? reacted;
  final ValueChanged<ReactionsEmojiCount>? onPressed;
  final ValueChanged<ReactionsEmojiCount>? onLongPressed;
  final OBEmojiReactionButtonSize size;

  const OBEmojiReactionButton(this.postReactionsEmojiCount,
      {Key? key,
      this.onPressed,
      this.reacted,
      this.onLongPressed,
      this.size = OBEmojiReactionButtonSize.medium})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var emoji = postReactionsEmojiCount.emoji!;

    List<Widget> buttonRowItems = [
      CachedNetworkImage(
        height: size == OBEmojiReactionButtonSize.medium ? 18 : 14,
        width: size == OBEmojiReactionButtonSize.medium ? 18 : 14,
        imageUrl: emoji.image ?? '',
        placeholder: (context, url) => SizedBox(
          height: size == OBEmojiReactionButtonSize.medium ? 18 : 14,
          width: size == OBEmojiReactionButtonSize.medium ? 18 : 14,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        errorWidget: (context, url, error) => Icon(Icons.error,
            size: size == OBEmojiReactionButtonSize.medium ? 18 : 14),
      ),
      const SizedBox(
        width: 10.0,
      ),
      OBText(
        postReactionsEmojiCount.getPrettyCount(),
        style: TextStyle(
            fontWeight: (reacted == true) ? FontWeight.bold : FontWeight.normal,
            fontSize: size == OBEmojiReactionButtonSize.medium ? null : 12),
      )
    ];

    Widget buttonChild = Row(
        mainAxisAlignment: MainAxisAlignment.center, children: buttonRowItems);

    return OBButton(
      minWidth: 50,
      onLongPressed: () {
        if (onLongPressed != null) onLongPressed!(postReactionsEmojiCount);
      },
      onPressed: () {
        if (onPressed != null) onPressed!(postReactionsEmojiCount);
      },
      type: OBButtonType.highlight,
      child: buttonChild,
    );
  }
}

enum OBEmojiReactionButtonSize { small, medium }
