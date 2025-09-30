import 'package:Kootumb/pages/home/pages/menu/pages/themes/widgets/curated_themes.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/icon_button.dart';
import 'package:Kootumb/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';

class OBThemesPage extends StatelessWidget {
  const OBThemesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocalizationService localizationService =
        KongoProvider.of(context).localizationService;
    return CupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: localizationService.drawer__themes,
        leading: OBIconButton(
          OBIcons.close,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      child: OBPrimaryColorContainer(
        child: Column(
          children: <Widget>[
            Expanded(
                child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[OBCuratedThemes()],
            )),
          ],
        ),
      ),
    );
  }
}
