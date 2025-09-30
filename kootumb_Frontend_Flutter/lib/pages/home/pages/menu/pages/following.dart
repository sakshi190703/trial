import 'dart:async';

import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/models/users_list.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/services/navigation_service.dart';
import 'package:Kootumb/widgets/buttons/actions/follow_button.dart';
import 'package:Kootumb/widgets/http_list.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/icon_button.dart';
import 'package:Kootumb/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Kootumb/widgets/page_scaffold.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/user.dart';
import 'package:Kootumb/widgets/theming/primary_color_container.dart';
import 'package:Kootumb/widgets/tiles/user_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBFollowingPage extends StatefulWidget {
  const OBFollowingPage({Key? key}) : super(key: key);

  @override
  State<OBFollowingPage> createState() {
    return OBFollowingPageState();
  }
}

class OBFollowingPageState extends State<OBFollowingPage> {
  late UserService _userService;
  late NavigationService _navigationService;
  late LocalizationService _localizationService;

  late OBHttpListController _httpListController;
  late bool _needsBootstrap;

  @override
  void initState() {
    super.initState();
    _httpListController = OBHttpListController();
    _needsBootstrap = true;
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var provider = KongoProvider.of(context);
      _userService = provider.userService;
      _navigationService = provider.navigationService;
      _localizationService = provider.localizationService;
      _needsBootstrap = false;
    }

    return OBCupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: _localizationService.user__following_text,
        leading: OBIconButton(
          OBIcons.close,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      child: OBPrimaryColorContainer(
        child: OBHttpList<User>(
          controller: _httpListController,
          listItemBuilder: _buildFollowingListItem,
          searchResultListItemBuilder: _buildFollowingListItem,
          listRefresher: _refreshFollowing,
          listOnScrollLoader: _loadMoreFollowing,
          listSearcher: _searchFollowing,
          resourceSingularName:
              _localizationService.user__following_resource_name,
          resourcePluralName:
              _localizationService.user__following_resource_name,
        ),
      ),
    );
  }

  Widget _buildFollowingListItem(BuildContext context, User user) {
    return OBUserTile(user,
        onUserTilePressed: _onFollowingListItemPressed,
        trailing: OBFollowButton(
          user,
          size: OBButtonSize.small,
          unfollowButtonType: OBButtonType.highlight,
        ));
  }

  void _onFollowingListItemPressed(User following) {
    _navigationService.navigateToUserProfile(user: following, context: context);
  }

  Future<List<User>> _refreshFollowing() async {
    UsersList following = await _userService.getFollowings();
    return following.users ?? [];
  }

  Future<List<User>> _loadMoreFollowing(List<User> followingList) async {
    var lastFollowing = followingList.last;
    var lastFollowingId = lastFollowing.id;
    var moreFollowing = (await _userService.getFollowings(
      maxId: lastFollowingId,
      count: 20,
    ))
        .users;
    return moreFollowing ?? [];
  }

  Future<List<User>> _searchFollowing(String query) async {
    UsersList results = await _userService.searchFollowings(query: query);

    return results.users ?? [];
  }
}
