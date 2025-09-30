import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/icon_button.dart';
import 'package:Kootumb/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Kootumb/widgets/theming/primary_color_container.dart';
import 'package:Kootumb/widgets/tile_group_title.dart';
import 'package:Kootumb/widgets/tiles/actions/hashtags_display_setting_tile.dart';
import 'package:Kootumb/widgets/tiles/actions/link_previews_setting_tile.dart';
import 'package:Kootumb/widgets/tiles/actions/videos_autoplay_setting_tile.dart';
import 'package:Kootumb/widgets/tiles/actions/videos_sound_setting_tile.dart';
import 'package:flutter/cupertino.dart';

class OBApplicationSettingsPage extends StatelessWidget {
  const OBApplicationSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocalizationService localizationService =
        KongoProvider.of(context).localizationService;

    return CupertinoPageScaffold(
      backgroundColor: Color.fromARGB(0, 0, 0, 0),
      navigationBar: OBThemedNavigationBar(
        title: localizationService.drawer__application_settings,
        leading: OBIconButton(
          OBIcons.close,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      child: OBPrimaryColorContainer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: OBTileGroupTitle(
                title: localizationService.application_settings__videos,
              ),
            ),
            OBVideosSoundSettingTile(),
            OBVideosAutoPlaySettingTile(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: OBTileGroupTitle(
                title: localizationService.application_settings__link_previews,
              ),
            ),
            OBLinkPreviewsSettingTile(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: OBTileGroupTitle(
                title: localizationService.application_settings__hashtags,
              ),
            ),
            OBHashtagsDisplaySettingTile()
          ],
        ),
      ),
    );
  }
}
