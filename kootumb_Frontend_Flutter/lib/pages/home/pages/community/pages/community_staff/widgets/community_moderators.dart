import 'package:Kootumb/models/community.dart';
import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/navigation_service.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:Kootumb/widgets/tiles/user_tile.dart';
import 'package:flutter/material.dart';

class OBCommunityModerators extends StatelessWidget {
  final Community community;

  const OBCommunityModerators(this.community, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: community.updateSubject,
      initialData: community,
      builder: (BuildContext context, AsyncSnapshot<Community> snapshot) {
        var community = snapshot.data;

        List<User>? communityModerators = community?.moderators?.users;

        if (communityModerators!.isEmpty) return const SizedBox();

        return Row(
          children: <Widget>[
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Row(children: [
                      OBIcon(
                        OBIcons.communityModerators,
                        size: OBIconSize.medium,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      OBText(
                        'Moderators',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      )
                    ]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListView(
                    padding: EdgeInsets.all(0),
                    shrinkWrap: true,
                    children:
                        communityModerators.map((User communityModerator) {
                      return OBUserTile(
                        communityModerator,
                        onUserTilePressed: (User user) {
                          NavigationService navigationService =
                              KongoProvider.of(context).navigationService;
                          navigationService.navigateToUserProfile(
                              user: communityModerator, context: context);
                        },
                      );
                    }).toList(),
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
