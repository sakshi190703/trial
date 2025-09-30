import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/icon_button.dart';
import 'package:Kootumb/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:Kootumb/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class OBAboutPage extends StatefulWidget {
  const OBAboutPage({Key? key}) : super(key: key);

  @override
  OBAboutPageState createState() {
    return OBAboutPageState();
  }
}

// TODO The get_version plugin does not work for iOS.

class OBAboutPageState extends State<OBAboutPage> {
  @override
  void initState() {
    super.initState();
    initStateAsync();
  }

  void initStateAsync() async {
    var pi = await PackageInfo.fromPlatform();

    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    LocalizationService localizationService =
        KongoProvider.of(context).localizationService;

    var kongoProvider = KongoProvider.of(context);
    var urlLauncherService = kongoProvider.urlLauncherService;

    return CupertinoPageScaffold(
      backgroundColor: Color.fromARGB(0, 0, 0, 0),
      navigationBar: OBThemedNavigationBar(
        title: localizationService.drawer__about,
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
              leading: OBIcon(OBIcons.nativeInfo),
              title: OBText('Kootumb v1.2.10'),
            ),
            ListTile(
              leading: const OBIcon(OBIcons.link),
              title: OBText("Policies"),
              onTap: () {
                urlLauncherService
                    .launchUrlInApp('https://kootumb.com/policies.html');
              },
            ),
          ],
        ),
      ),
    );
  }
}
