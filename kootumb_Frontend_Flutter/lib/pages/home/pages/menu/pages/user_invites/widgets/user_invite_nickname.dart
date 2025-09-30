import 'package:Kootumb/models/user_invite.dart';
import 'package:Kootumb/widgets/theming/primary_accent_text.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:Kootumb/widgets/theming/secondary_text.dart';
import 'package:flutter/material.dart';

class OBUserInviteNickname extends StatelessWidget {
  final UserInvite userInvite;

  const OBUserInviteNickname(this.userInvite, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: userInvite.updateSubject,
        initialData: userInvite,
        builder: (BuildContext context, AsyncSnapshot<UserInvite> snapshot) {
          var userInvite = snapshot.data;
          if (userInvite == null) return const SizedBox();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              OBSecondaryText(
                'Nickname',
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Flexible(
                    child: OBPrimaryAccentText(
                      userInvite.nickname ?? '',
                      size: OBTextSize.extraLarge,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          );
        });
  }
}
