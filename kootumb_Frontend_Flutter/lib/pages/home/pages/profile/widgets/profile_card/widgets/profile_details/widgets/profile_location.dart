import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBProfileLocation extends StatelessWidget {
  final User user;

  const OBProfileLocation(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? location = user.getProfileLocation();

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const OBIcon(OBIcons.location, customSize: 14),
        const SizedBox(width: 10),
        Flexible(
          child: OBText(location ?? '',
              maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}
