import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/icon_button.dart';
import 'package:Kootumb/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/widgets/theming/primary_color_container.dart';
import 'package:Kootumb/widgets/theming/secondary_text.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBUsefulLinksPage extends StatelessWidget {
  const OBUsefulLinksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var kongoProvider = KongoProvider.of(context);
    var urlLauncherService = kongoProvider.urlLauncherService;
    var localizationService = kongoProvider.localizationService;

    return CupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: localizationService.drawer__useful_links_title,
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
              children: <Widget>[
                ListTile(
                  leading: const OBIcon(OBIcons.link),
                  title: OBText("Kootumb Policies"),
                  subtitle:
                      OBSecondaryText("Complete policies, terms & privacy"),
                  onTap: () {
                    urlLauncherService
                        .launchUrlInApp('https://kootumb.com/policies.html');
                  },
                ),
                ListTile(
                  leading: const OBIcon(OBIcons.guide),
                  title: OBText(
                      localizationService.drawer__useful_links_guidelines),
                  subtitle: OBSecondaryText(
                      localizationService.drawer__useful_links_guidelines_desc),
                  onTap: () {
                    urlLauncherService
                        .launchUrlInApp('https://kootumb.com/policies.html');
                  },
                ),
                ListTile(
                  leading: const OBIcon(OBIcons.lock),
                  title: OBText(
                      localizationService.drawer__useful_links_privacy_policy),
                  subtitle: OBSecondaryText(localizationService
                      .drawer__useful_links_privacy_policy_desc),
                  onTap: () {
                    urlLauncherService
                        .launchUrlInApp('https://kootumb.com/policies.html');
                  },
                ),
                ListTile(
                  leading: const OBIcon(OBIcons.communityModerators),
                  title: OBText(
                      localizationService.drawer__useful_links_terms_of_use),
                  subtitle: OBSecondaryText(localizationService
                      .drawer__useful_links_terms_of_use_desc),
                  onTap: () {
                    urlLauncherService
                        .launchUrlInApp('https://kootumb.com/policies.html');
                  },
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
