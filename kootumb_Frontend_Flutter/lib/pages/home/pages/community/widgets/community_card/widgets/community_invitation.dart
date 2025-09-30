import 'package:Kootumb/models/community.dart';
import 'package:Kootumb/widgets/alerts/alert.dart';
import 'package:Kootumb/widgets/buttons/actions/join_community_button.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBCommunityInvitation extends StatelessWidget {
  final Community community;

  const OBCommunityInvitation(this.community, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: community.updateSubject,
      initialData: community,
      builder: (BuildContext context, AsyncSnapshot<Community> snapshot) {
        Community? community = snapshot.data;
        bool? isInvited = community?.isInvited;

        return Column(
          children: <Widget>[
            const SizedBox(height: 20),
            OBAlert(
              child: Column(
                children: <Widget>[
                  OBText(
                    'You have been invited to join the community.',
                    maxLines: 4,
                    size: OBTextSize.medium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[OBJoinCommunityButton(community!)],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
