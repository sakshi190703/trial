import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/bottom_sheet.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/services/user_preferences.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/theming/primary_accent_text.dart';
import 'package:Kootumb/widgets/theming/secondary_text.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBLinkPreviewsSettingTile extends StatelessWidget {
  const OBLinkPreviewsSettingTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    KongoProviderState provider = KongoProvider.of(context);

    LocalizationService localizationService = provider.localizationService;
    UserPreferencesService userPreferencesService =
        provider.userPreferencesService;
    BottomSheetService bottomSheetService = provider.bottomSheetService;

    Map<LinkPreviewsSetting, String> linkPreviewsSettingsLocalizationMap =
        userPreferencesService.getLinkPreviewsSettingLocalizationMap();

    return FutureBuilder(
      future: userPreferencesService.getLinkPreviewsSetting(),
      builder:
          (BuildContext context, AsyncSnapshot<LinkPreviewsSetting?> snapshot) {
        if (snapshot.data == null) return const SizedBox();

        return StreamBuilder(
          stream: userPreferencesService.linkPreviewsSettingChange,
          initialData: snapshot.data,
          builder: (BuildContext context,
              AsyncSnapshot<LinkPreviewsSetting> snapshot) {
            LinkPreviewsSetting currentLinkPreviewsSetting = snapshot.data!;

            return MergeSemantics(
              child: ListTile(
                  leading: OBIcon(OBIcons.linkPreviews),
                  title: OBText(
                    localizationService
                        .application_settings__link_previews_show,
                  ),
                  subtitle: OBSecondaryText(
                    localizationService.application_settings__tap_to_change,
                    size: OBTextSize.small,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      OBPrimaryAccentText(
                        linkPreviewsSettingsLocalizationMap[
                            currentLinkPreviewsSetting]!,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  onTap: () {
                    bottomSheetService.showLinkPreviewsSettingPicker(
                        initialValue: currentLinkPreviewsSetting,
                        context: context,
                        onChanged:
                            (LinkPreviewsSetting newLinkPreviewsSetting) {
                          userPreferencesService
                              .setLinkPreviewsSetting(newLinkPreviewsSetting);
                        });
                  }),
            );
          },
        );
      },
    );
  }
}
