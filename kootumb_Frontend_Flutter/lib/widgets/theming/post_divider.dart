import 'package:Kootumb/models/theme.dart';
import 'package:Kootumb/provider.dart';
import 'package:flutter/material.dart';
import 'package:tinycolor2/tinycolor2.dart';

class OBPostDivider extends StatelessWidget {
  const OBPostDivider({Key? key}) : super(key: key);

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

          Color color = themeValueParserService.parseColor(theme!.primaryColor);

          TinyColor modifiedColor = themeValueParserService.isDarkColor(color)
              ? TinyColor(color).lighten(30)
              : TinyColor(color).darken(30);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                    color: modifiedColor.color,
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                height: 1,
              ),
            ),
          );
        });
  }
}
