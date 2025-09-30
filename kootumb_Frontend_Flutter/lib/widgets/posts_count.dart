import 'package:Kootumb/libs/pretty_count.dart';
import 'package:Kootumb/models/theme.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:flutter/material.dart';

class OBPostsCount extends StatelessWidget {
  final int? postsCount;
  final bool showZero;
  final Color? color;
  final double? fontSize;

  const OBPostsCount(this.postsCount,
      {Key? key, this.showZero = false, this.color, this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (postsCount == null || (postsCount == 0 && !showZero)) {
      return const SizedBox();
    }

    var kongoProvider = KongoProvider.of(context);
    var themeService = kongoProvider.themeService;
    var themeValueParserService = kongoProvider.themeValueParserService;
    LocalizationService localizationService = kongoProvider.localizationService;
    String count = getPrettyCount(postsCount!, localizationService);

    return StreamBuilder(
        stream: themeService.themeChange,
        initialData: themeService.getActiveTheme(),
        builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
          var theme = snapshot.data;

          return Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: count,
                      style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          color: color ??
                              themeValueParserService
                                  .parseColor(theme!.primaryTextColor))),
                  TextSpan(
                      text: postsCount == 1
                          ? localizationService.post__profile_counts_post
                          : localizationService.post__profile_counts_posts,
                      style: TextStyle(
                          fontSize: fontSize,
                          color: color ??
                              themeValueParserService
                                  .parseColor(theme!.secondaryTextColor)))
                ])),
              ),
              const SizedBox(
                width: 10,
              )
            ],
          );
        });
  }
}
