import 'package:Kootumb/models/theme.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/theme_value_parser.dart';
import 'package:Kootumb/services/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class OBMarkdown extends StatelessWidget {
  static final double pFontSize = 16;

  final String data;
  final OBTheme? theme;
  final bool onlyBody;

  const OBMarkdown(
      {Key? key, required this.data, this.theme, this.onlyBody = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var kongoProvider = KongoProvider.of(context);
    var themeValueParserService = kongoProvider.themeValueParserService;
    var urlLauncherService = kongoProvider.urlLauncherService;

    if (theme != null) {
      return _buildWithTheme(theme!,
          context: context,
          themeValueParserService: themeValueParserService,
          urlLauncherService: urlLauncherService);
    }

    var themeService = kongoProvider.themeService;

    return StreamBuilder(
      stream: themeService.themeChange,
      initialData: themeService.getActiveTheme(),
      builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
        var currentTheme = snapshot.data;
        return _buildWithTheme(currentTheme!,
            context: context,
            themeValueParserService: themeValueParserService,
            urlLauncherService: urlLauncherService);
      },
    );
  }

  Widget _buildWithTheme(OBTheme theme,
      {required ThemeValueParserService themeValueParserService,
      required UrlLauncherService urlLauncherService,
      required BuildContext context}) {
    var primaryColor = themeValueParserService.parseColor(theme.primaryColor);
    final bool isDarkPrimaryColor = primaryColor.computeLuminance() < 0.179;
    Color primaryTextColor =
        themeValueParserService.parseColor(theme.primaryTextColor);
    Color accentColor = isDarkPrimaryColor
        ? Color.fromARGB(10, 0, 0, 0)
        : Color.fromARGB(20, 255, 255, 255);
    Color actionsForegroundColor = themeValueParserService
        .parseGradient(theme.primaryAccentColor)
        .colors[1];

    ThemeData flutterTheme = Theme.of(context);

    MarkdownStyleSheet styleSheet = MarkdownStyleSheet.fromTheme(flutterTheme)
        .copyWith(
            code: TextStyle(
                color: primaryTextColor,
                fontFamily: "monospace",
                fontSize: flutterTheme.textTheme.bodyMedium!.fontSize! * 0.85),
            h1: flutterTheme.textTheme.headlineSmall!
                .copyWith(color: primaryTextColor, fontWeight: FontWeight.bold),
            h2: flutterTheme.textTheme.titleLarge!
                .copyWith(color: primaryTextColor, fontWeight: FontWeight.bold),
            h3: flutterTheme.textTheme.titleMedium!
                .copyWith(color: primaryTextColor, fontWeight: FontWeight.bold),
            h4: flutterTheme.textTheme.bodyLarge!
                .copyWith(color: primaryTextColor, fontWeight: FontWeight.bold),
            h5: flutterTheme.textTheme.bodyLarge!
                .copyWith(color: primaryTextColor, fontWeight: FontWeight.bold),
            h6: flutterTheme.textTheme.bodyLarge!
                .copyWith(color: primaryTextColor, fontWeight: FontWeight.bold),
            em: const TextStyle(fontStyle: FontStyle.italic),
            strong: const TextStyle(fontWeight: FontWeight.bold),
            img: flutterTheme.textTheme.bodyMedium!
                .copyWith(color: primaryTextColor),
            codeblockDecoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(2.0)),
            horizontalRuleDecoration: BoxDecoration(
              border: Border(top: BorderSide(width: 2.0, color: accentColor)),
            ),
            blockSpacing: 10.0,
            listIndent: 32.0,
            blockquotePadding: EdgeInsets.all(10.0),
            p: flutterTheme.textTheme.bodyMedium!
                .copyWith(color: primaryTextColor, fontSize: pFontSize),
            a: TextStyle(color: actionsForegroundColor, fontSize: pFontSize),
            blockquoteDecoration: BoxDecoration(
                color: accentColor, borderRadius: BorderRadius.circular(5.0)));

    onTapLink(String text, String? tappedLink, String title) async {
      if (tappedLink == null) {
        return;
      }

      bool canLaunchUrl = await urlLauncherService.canLaunchUrl(tappedLink);
      if (canLaunchUrl) {
        urlLauncherService.launchUrl(tappedLink);
      }
    }

    return onlyBody
        ? MarkdownBody(
            data: data,
            styleSheet: styleSheet,
            onTapLink: onTapLink,
          )
        : Markdown(
            data: data,
            styleSheet: styleSheet,
            onTapLink: onTapLink,
          );
  }
}
