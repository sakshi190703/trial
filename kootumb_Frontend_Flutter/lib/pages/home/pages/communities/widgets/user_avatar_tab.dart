import 'package:Kootumb/models/theme.dart';
import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/theme.dart';
import 'package:Kootumb/services/theme_value_parser.dart';
import 'package:Kootumb/widgets/alerts/alert.dart';
import 'package:Kootumb/widgets/avatars/avatar.dart';
import 'package:Kootumb/widgets/tabs/image_tab.dart';
import 'package:flutter/material.dart';

class OBUserAvatarTab extends StatelessWidget {
  final User user;

  const OBUserAvatarTab({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    KongoProviderState kongoProvider = KongoProvider.of(context);
    ThemeService themeService = kongoProvider.themeService;
    ThemeValueParserService themeValueParser =
        kongoProvider.themeValueParserService;
    OBTheme theme = themeService.getActiveTheme();

    Gradient themeGradient =
        themeValueParser.parseGradient(theme.primaryAccentColor);

    return OBAlert(
        borderRadius: BorderRadius.circular(OBImageTab.borderRadius),
        padding: EdgeInsets.all(0),
        height: OBImageTab.height,
        width: OBImageTab.width * 0.8,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              OBAvatar(
                size: OBAvatarSize.small,
                avatarUrl: user.getProfileAvatar(),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      decoration: BoxDecoration(
                          gradient: themeGradient,
                          borderRadius: BorderRadius.only(
                              bottomLeft:
                                  Radius.circular(OBImageTab.borderRadius),
                              bottomRight:
                                  Radius.circular(OBImageTab.borderRadius))),
                      child: Text(
                        'You',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
