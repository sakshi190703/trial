import 'package:Kootumb/provider.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/icon_button.dart';
import 'package:Kootumb/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Kootumb/widgets/theming/primary_color_container.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBSettingsPage extends StatelessWidget {
  const OBSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var kongoProvider = KongoProvider.of(context);
    var navigationService = kongoProvider.navigationService;
    var localizationService = kongoProvider.localizationService;

    return CupertinoPageScaffold(
      backgroundColor: Color.fromARGB(0, 0, 0, 0),
      navigationBar: OBThemedNavigationBar(
        title: localizationService.trans('drawer__settings'),
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
          padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              leading: const OBIcon(OBIcons.account),
              title:
                  OBText(localizationService.trans('drawer__account_settings')),
              onTap: () {
                navigationService.navigateToAccountSettingsPage(
                    context: context);
              },
            ),
            ListTile(
              leading: const OBIcon(OBIcons.application),
              title: OBText(
                  localizationService.trans('drawer__application_settings')),
              onTap: () {
                navigationService.navigateToApplicationSettingsPage(
                    context: context);
              },
            ),
            // ListTile(
            //   leading: const OBIcon(OBIcons.bug),
            //   title: OBText(localizationService.drawer__developer_settings),
            //   onTap: () {
            //     navigationService.navigateToDeveloperSettingsPage(
            //         context: context);
            //   },
            // ),
            ListTile(
              leading: const OBIcon(OBIcons.nativeInfo),
              title: OBText(localizationService.drawer__about),
              onTap: () {
                navigationService.navigateToAboutPage(context: context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
