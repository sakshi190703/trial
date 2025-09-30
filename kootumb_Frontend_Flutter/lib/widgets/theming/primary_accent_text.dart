import 'package:Kootumb/models/theme.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBPrimaryAccentText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final OBTextSize? size;
  final TextOverflow overflow;
  final int? maxLines;

  const OBPrimaryAccentText(this.text,
      {Key? key,
      this.style,
      this.size,
      this.maxLines,
      this.overflow = TextOverflow.ellipsis})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeService = KongoProvider.of(context).themeService;
    var themeValueParserService =
        KongoProvider.of(context).themeValueParserService;

    return StreamBuilder(
        stream: themeService.themeChange,
        initialData: themeService.getActiveTheme(),
        builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
          var theme = snapshot.data;

          TextStyle? finalStyle = style;
          TextStyle themedTextStyle = TextStyle(
              foreground: Paint()
                ..shader = themeValueParserService
                    .parseGradient(theme!.primaryAccentColor)
                    .createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)));

          if (finalStyle != null) {
            finalStyle = finalStyle.merge(themedTextStyle);
          } else {
            finalStyle = themedTextStyle;
          }

          return OBText(
            text,
            style: finalStyle,
            size: size ?? OBTextSize.medium,
            overflow: overflow,
            maxLines: maxLines,
          );
        });
  }
}
