import 'package:Kootumb/models/community.dart';
import 'package:Kootumb/pages/home/pages/community/pages/manage_community/pages/community_closed_posts/widgets/closed_posts.dart';
import 'package:Kootumb/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Kootumb/widgets/page_scaffold.dart';
import 'package:Kootumb/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBCommunityClosedPostsPage extends StatelessWidget {
  final Community community;

  const OBCommunityClosedPostsPage(this.community, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OBCupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: 'Closed posts',
      ),
      child: OBPrimaryColorContainer(
          child: OBCommunityClosedPosts(community: community)),
    );
  }
}
