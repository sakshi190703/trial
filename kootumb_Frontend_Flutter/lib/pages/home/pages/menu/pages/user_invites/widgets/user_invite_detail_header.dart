import 'package:Kootumb/models/user_invite.dart';
import 'package:Kootumb/pages/home/pages/menu/pages/user_invites/widgets/user_invite_nickname.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/theming/actionable_smart_text.dart';
import 'package:flutter/material.dart';

import '../../../../../../../provider.dart';

class OBUserInviteDetailHeader extends StatelessWidget {
  final UserInvite userInvite;

  const OBUserInviteDetailHeader(this.userInvite, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocalizationService localizationService =
        KongoProvider.of(context).localizationService;

    return StreamBuilder(
        stream: userInvite.updateSubject,
        initialData: userInvite,
        builder: (BuildContext context, AsyncSnapshot<UserInvite> snapshot) {
          var userInvite = snapshot.data!;

          List<Widget> columnItems = [_buildUserInviteNickname(userInvite)];

          columnItems
              .add(_buildUserDescription(userInvite, localizationService));

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: columnItems,
          );
        });
  }

  Widget _buildUserInviteNickname(UserInvite userInvite) {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20, top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: OBUserInviteNickname(userInvite),
          ),
        ],
      ),
    );
  }

  Widget _buildUserDescription(
      UserInvite userInvite, LocalizationService localizationService) {
    Widget description;
    if (userInvite.createdUser != null) {
      description = OBActionableSmartText(
          text: localizationService
              .user__invites_joined_with(userInvite.createdUser!.username!));
    } else if (userInvite.isInviteEmailSent == true) {
      description = OBText(
          localizationService.user__invites_pending_email(userInvite.email!));
    } else {
      description = OBText(localizationService.user__invites_pending);
    }

    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20, top: 10.0, bottom: 20),
      child: Column(
        children: <Widget>[
          description,
        ],
      ),
    );
  }
}
