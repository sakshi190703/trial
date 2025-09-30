import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Kootumb/widgets/theming/primary_color_container.dart';
import 'package:Kootumb/widgets/tiles/actions/clear_application_cache_tile.dart';
import 'package:flutter/cupertino.dart';

class OBDeveloperSettingsPage extends StatelessWidget {
  const OBDeveloperSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocalizationService localizationService =
        KongoProvider.of(context).localizationService;

    return CupertinoPageScaffold(
      backgroundColor: Color.fromARGB(0, 0, 0, 0),
      navigationBar: OBThemedNavigationBar(
          title: localizationService.drawer__developer_settings,
          leading: OBIcon(
            OBIcons.close,
            size: OBIconSize.notVisi,
          )),
      child: OBPrimaryColorContainer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            OBClearApplicationCacheTile(),
          ],
        ),
      ),
    );
  }
}
