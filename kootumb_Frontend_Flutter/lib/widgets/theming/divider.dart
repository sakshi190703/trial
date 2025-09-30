import 'package:Kootumb/models/theme.dart';
import 'package:Kootumb/provider.dart';
import 'package:flutter/material.dart';

class OBDivider extends StatelessWidget {
  const OBDivider({Key? key}) : super(key: key);

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

          return SizedBox(
            height: 16.0,
            child: Center(
              child: Container(
                height: 0.0,
                margin: EdgeInsetsDirectional.only(start: 0),
                decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                    color: themeValueParserService
                        .parseColor(theme!.secondaryTextColor),
                    width: 0.5,
                  )),
                ),
              ),
            ),
          );
        });
  }
}
