import 'package:Kootumb/models/theme.dart';
import 'package:Kootumb/provider.dart';
import 'package:flutter/material.dart';

class OBBadge extends StatelessWidget {
  final int? count;
  final double? size;

  const OBBadge({Key? key, this.count, this.size = 19}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var kongoProvider = KongoProvider.of(context);
    var themeService = kongoProvider.themeService;
    var themeValueParserService = kongoProvider.themeValueParserService;

    if (count == 0) return const SizedBox();

    return StreamBuilder(
        stream: themeService.themeChange,
        initialData: themeService.getActiveTheme(),
        builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
          var theme = snapshot.data;
          var primaryAccentColor =
              themeValueParserService.parseGradient(theme!.primaryAccentColor);
          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
                gradient: primaryAccentColor,
                borderRadius: BorderRadius.circular(50)),
            child: Center(
                child: count != null
                    ? Text(
                        count.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: count! < 10 ? 12 : 10,
                            fontWeight: FontWeight.bold),
                      )
                    : const SizedBox()),
          );
        });
  }
}
