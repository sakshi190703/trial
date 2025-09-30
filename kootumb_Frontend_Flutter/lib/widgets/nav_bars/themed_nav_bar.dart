import 'package:Kootumb/models/theme.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A navigation bar that uses the current theme colours
class OBThemedNavigationBar extends StatelessWidget
    implements ObstructingPreferredSizeWidget {
  final Widget? leading;
  final String? title;
  final Widget? trailing;
  final String? previousPageTitle;
  final Widget? middle;

  const OBThemedNavigationBar({
    Key? key,
    this.leading,
    this.previousPageTitle,
    this.title,
    this.trailing,
    this.middle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var kongoProvider = KongoProvider.of(context);
    var themeService = kongoProvider.themeService;
    var themeValueParserService = kongoProvider.themeValueParserService;

    return StreamBuilder(
      stream: themeService.themeChange,
      initialData: themeService.getActiveTheme(),
      builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
        var theme = snapshot.data;

        Color actionsForegroundColor = themeValueParserService
            .parseGradient(theme!.primaryAccentColor)
            .colors[1];

        Color actionsColor = actionsForegroundColor ?? Colors.black;

        CupertinoThemeData themeData = CupertinoTheme.of(context);

        return CupertinoTheme(
            data: themeData.copyWith(
                primaryColor: actionsColor,
                textTheme: CupertinoTextThemeData(
                  primaryColor:
                      actionsColor, //change color of the TOP navbar icon
                )),
            child: CupertinoNavigationBar(
              border: null,
              middle: middle ??
                  (title != null
                      ? OBText(
                          title!,
                        )
                      : const SizedBox()),
              transitionBetweenRoutes: false,
              backgroundColor:
                  themeValueParserService.parseColor(theme.primaryColor),
              trailing: trailing,
              leading: leading,
            ));
      },
    );
  }

  /// True if the navigation bar's background color has no transparency.
  @override
  bool get fullObstruction => true;

  @override
  Size get preferredSize {
    return const Size.fromHeight(44);
  }

  @override
  bool shouldFullyObstruct(BuildContext context) {
    return true;
  }
}
