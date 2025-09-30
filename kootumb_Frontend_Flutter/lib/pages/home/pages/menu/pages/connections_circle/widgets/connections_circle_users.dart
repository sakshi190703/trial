import 'package:Kootumb/models/circle.dart';
import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:Kootumb/widgets/tiles/user_tile.dart';
import 'package:flutter/material.dart';

class OBConnectionsCircleUsers extends StatelessWidget {
  final Circle connectionsCircle;

  const OBConnectionsCircleUsers(this.connectionsCircle, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = KongoProvider.of(context);
    var navigationService = provider.navigationService;
    LocalizationService localizationService = provider.localizationService;

    return StreamBuilder(
        stream: connectionsCircle.updateSubject,
        initialData: connectionsCircle,
        builder: (BuildContext context, AsyncSnapshot<Circle> snapshot) {
          var connectionsCircle = snapshot.data;
          List<User> users = connectionsCircle?.users?.users ?? [];

          onUserTilePressed(User user) {
            navigationService.navigateToUserProfile(
                user: user, context: context);
          }

          return ListView.builder(
              padding: EdgeInsets.all(0),
              itemCount: users.length,
              itemBuilder: (context, index) {
                var user = users[index];

                Widget? trailing;
                bool isFullyConnected = user.isFullyConnected ?? true;

                if (!isFullyConnected) {
                  trailing = Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      OBText(
                          localizationService.trans('user__connection_pending'))
                    ],
                  );
                }

                return OBUserTile(
                  user,
                  showFollowing: false,
                  onUserTilePressed: onUserTilePressed,
                  trailing: trailing,
                );
              });
        });
  }
}
