import 'package:Kootumb/models/theme.dart';
import 'package:Kootumb/provider.dart';
import 'package:flutter/material.dart';

class OBLinearProgressIndicator extends StatelessWidget {
  const OBLinearProgressIndicator({Key? key}) : super(key: key);

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

          var primaryColor =
              themeValueParserService.parseColor(theme!.primaryColor);
          final bool isDarkPrimaryColor =
              primaryColor.computeLuminance() < 0.179;

          final Color backgroundColor = isDarkPrimaryColor
              ? Color.fromARGB(30, 255, 255, 255)
              : Color.fromARGB(20, 0, 0, 0);

          final Color valueColor = kongoProvider.themeValueParserService
              .parseGradient(theme.primaryAccentColor)
              .colors[1];

          return LinearProgressIndicator(
            backgroundColor: backgroundColor,
            valueColor: AlwaysStoppedAnimation<Color>(valueColor),
          );
        });
  }
}
