import 'package:Kootumb/models/hashtag.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/user_preferences.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OBHashtag extends StatelessWidget {
  final Hashtag hashtag;
  final ValueChanged<Hashtag>? onPressed;
  final TextStyle? textStyle;
  final String? rawHashtagName;
  final EdgeInsets? discoDisplayMargin;

  const OBHashtag(
      {Key? key,
      required this.hashtag,
      this.onPressed,
      this.discoDisplayMargin,
      this.textStyle,
      this.rawHashtagName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle finalTextStyle = TextStyle(fontWeight: FontWeight.bold);

    KongoProviderState kongoProvider = KongoProvider.of(context);

    if (textStyle != null) finalTextStyle = finalTextStyle.merge(textStyle);

    String finalHashtagText = rawHashtagName ?? hashtag.name!;

    return StreamBuilder(
        stream:
            kongoProvider.userPreferencesService.hashtagsDisplaySettingChange,
        initialData: kongoProvider
                .userPreferencesService.currentHashtagsDisplaySetting ??
            HashtagsDisplaySetting.traditional,
        builder: (BuildContext context,
            AsyncSnapshot<HashtagsDisplaySetting> snapshot) {
          return snapshot.data == HashtagsDisplaySetting.traditional
              ? _buildTraditionalHashtag(
                  context: context,
                  style: finalTextStyle,
                  text: finalHashtagText)
              : _buildDiscoHashtag(
                  context: context,
                  provider: kongoProvider,
                  style: finalTextStyle,
                  text: finalHashtagText);
        });
  }

  Widget _buildDiscoHashtag(
      {required BuildContext context,
      required TextStyle style,
      required String text,
      required KongoProviderState provider}) {
    Color hashtagBackgroundColor =
        provider.utilsService.parseHexColor(hashtag.color!);

    Widget content = Container(
      decoration: BoxDecoration(
        color: hashtagBackgroundColor,
        borderRadius: BorderRadius.circular(5),
      ),
      margin: discoDisplayMargin,
      padding: const EdgeInsets.symmetric(horizontal: 2.5),
      child: OBText(
        text,
        style: style.copyWith(color: Colors.white),
      ),
    );

    if (hashtag.hasEmoji()) content = _wrapWithHashtagEmoji(content);

    return _wrapWithGestureDetector(content);
  }

  Widget _buildTraditionalHashtag(
      {required BuildContext context,
      required TextStyle style,
      required String text}) {
    Widget content = OBText(
      '#$text',
      style: style,
    );

    if (hashtag.hasEmoji()) content = _wrapWithHashtagEmoji(content);

    return _wrapWithGestureDetector(content);
  }

  Widget _wrapWithGestureDetector(Widget child) {
    return GestureDetector(
        onTap: onPressed != null ? () => onPressed!(hashtag) : null,
        child: child);
  }

  Widget _wrapWithHashtagEmoji(Widget child) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        child,
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: hashtag.emoji?.image != null
              ? CachedNetworkImage(
                  height: 15,
                  imageUrl: hashtag.emoji!.image!,
                  placeholder: (context, url) => SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  errorWidget: (context, url, error) =>
                      Icon(Icons.error, size: 15),
                )
              : SizedBox.shrink(),
        ),
      ],
    );
  }
}
