import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBProfileUrl extends StatelessWidget {
  final User user;

  const OBProfileUrl(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? url = user.getProfileUrl();

    return GestureDetector(
      onTap: () async {
        KongoProviderState kongoProvider = KongoProvider.of(context);
        kongoProvider.urlLauncherService.launchUrl(url!);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const OBIcon(OBIcons.link, customSize: 14),
          const SizedBox(width: 10),
          Flexible(
            child: OBText(
              url ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(decoration: TextDecoration.underline),
            ),
          ),
        ],
      ),
    );
  }
}
