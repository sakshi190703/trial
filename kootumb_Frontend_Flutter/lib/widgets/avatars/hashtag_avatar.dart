import 'package:Kootumb/models/hashtag.dart';
import 'package:Kootumb/provider.dart';
export 'package:Kootumb/widgets/avatars/avatar.dart';
import 'package:Kootumb/widgets/avatars/letter_avatar.dart';
import 'package:flutter/material.dart';

class OBHashtagAvatar extends StatelessWidget {
  final Hashtag hashtag;
  final OBAvatarSize size;
  final VoidCallback? onPressed;
  final bool isZoomable;
  final double? borderRadius;
  final double? customSize;

  const OBHashtagAvatar(
      {Key? key,
      required this.hashtag,
      this.size = OBAvatarSize.small,
      this.isZoomable = false,
      this.borderRadius,
      this.onPressed,
      this.customSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: hashtag.updateSubject,
        initialData: hashtag,
        builder: (BuildContext context, AsyncSnapshot<Hashtag> snapshot) {
          Hashtag hashtag = snapshot.data!;
          bool hashtagHasImage = hashtag.hasImage();

          Widget avatar;

          if (hashtagHasImage) {
            avatar = OBAvatar(
                avatarUrl: hashtag.image,
                size: size,
                onPressed: onPressed,
                isZoomable: isZoomable,
                borderRadius: borderRadius,
                customSize: customSize);
          } else {
            String hashtagHexColor = hashtag.color!;

            KongoProviderState kongoProviderState = KongoProvider.of(context);

            Color hashtagColor =
                kongoProviderState.utilsService.parseHexColor(hashtagHexColor);
            Color textColor = Colors.white;

            avatar = OBLetterAvatar(
                letter: '#',
                color: hashtagColor,
                size: size,
                onPressed: onPressed,
                borderRadius: borderRadius,
                labelColor: textColor,
                customSize: customSize);
          }

          return avatar;
        });
  }
}
