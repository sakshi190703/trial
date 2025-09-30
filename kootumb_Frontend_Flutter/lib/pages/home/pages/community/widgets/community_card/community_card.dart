import 'package:Kootumb/models/community.dart';
import 'package:Kootumb/pages/home/pages/community/widgets/community_card/widgets/community_actions/community_actions.dart';
import 'package:Kootumb/pages/home/pages/community/widgets/community_card/widgets/community_buttons.dart';
import 'package:Kootumb/pages/home/pages/community/widgets/community_card/widgets/community_categories.dart';
import 'package:Kootumb/pages/home/pages/community/widgets/community_card/widgets/community_description.dart';
import 'package:Kootumb/pages/home/pages/community/widgets/community_card/widgets/community_details/community_details.dart';
import 'package:Kootumb/pages/home/pages/community/widgets/community_card/widgets/community_name.dart';
import 'package:Kootumb/pages/home/pages/community/widgets/community_card/widgets/community_title.dart';
import 'package:Kootumb/widgets/avatars/community_avatar.dart';
import 'package:flutter/material.dart';

class OBCommunityCard extends StatelessWidget {
  final Community community;

  const OBCommunityCard(this.community, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20, left: 30.0, right: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              OBCommunityAvatar(
                community: community,
                size: OBAvatarSize.large,
                isZoomable: true,
              ),
              Expanded(child: OBCommunityActions(community)),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              OBCommunityTitle(community),
              OBCommunityName(community),
              OBCommunityDescription(community),
              const SizedBox(
                height: 15,
              ),
              OBCommunityDetails(community),
              OBCommunityCategories(community),
              const SizedBox(
                height: 10,
              ),
              OBCommunityButtons(
                community: community,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
