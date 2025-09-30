import 'package:Kootumb/models/theme.dart';
import 'package:Kootumb/pages/home/pages/menu/pages/themes/widgets/theme_preview.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/theme.dart';
import 'package:flutter/material.dart';

class OBCuratedThemes extends StatelessWidget {
  late ThemeService _themeService;

  OBCuratedThemes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _themeService = KongoProvider.of(context).themeService;

    return Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GridView.extent(
                padding: EdgeInsets.symmetric(vertical: 20),
                primary: false,
                physics: const NeverScrollableScrollPhysics(),
                maxCrossAxisExtent: OBThemePreview.maxWidth,
                shrinkWrap: true,
                children: _buildThemePreviews(),
              ),
            ],
          ),
        ));
  }

  List<Widget> _buildThemePreviews() {
    var themes = _themeService.getCuratedThemes();
    var res = <Widget>[];

    for (var theme in themes) {
      var builder = Builder(builder: (buildContext) {
        return OBThemePreview(
          theme,
          onThemePreviewPressed: (OBTheme theme) {
            _themeService.setActiveTheme(theme);
          },
        );
      });

      res.add(builder);
    }

    return res;
  }
}
