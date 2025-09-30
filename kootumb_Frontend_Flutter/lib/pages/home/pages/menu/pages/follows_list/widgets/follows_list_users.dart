import 'package:Kootumb/models/follows_list.dart';
import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/widgets/tiles/user_tile.dart';
import 'package:flutter/material.dart';

class OBFollowsListUsers extends StatelessWidget {
  final FollowsList followsList;

  const OBFollowsListUsers(this.followsList, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var navigationService = KongoProvider.of(context).navigationService;
    return StreamBuilder(
        stream: followsList.updateSubject,
        initialData: followsList,
        builder: (BuildContext context, AsyncSnapshot<FollowsList> snapshot) {
          var followsList = snapshot.data;
          List<User> users = followsList?.users?.users ?? [];

          return ListView.builder(
              padding: EdgeInsets.all(0),
              itemCount: users.length,
              itemBuilder: (context, index) {
                var user = users[index];
                return OBUserTile(
                  user,
                  showFollowing: false,
                  onUserTilePressed: (User user) {
                    navigationService.navigateToUserProfile(
                        user: user, context: context);
                  },
                );
              });
        });
  }
}
