import 'dart:async';

import 'package:Kootumb/models/communities_list.dart';
import 'package:Kootumb/models/community.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/http_list.dart';
import 'package:Kootumb/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/user.dart';
import 'package:Kootumb/widgets/theming/primary_color_container.dart';
import 'package:Kootumb/widgets/tiles/community_tile.dart';
import 'package:flutter/cupertino.dart';

class OBExcludeCommunitiesFromProfilePostsModal extends StatefulWidget {
  const OBExcludeCommunitiesFromProfilePostsModal({Key? key}) : super(key: key);

  @override
  State<OBExcludeCommunitiesFromProfilePostsModal> createState() {
    return OBProfilePostsExcludedCommunitiesState();
  }
}

class OBProfilePostsExcludedCommunitiesState
    extends State<OBExcludeCommunitiesFromProfilePostsModal> {
  late UserService _userService;
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
      _localizationService = provider.localizationService;
      _needsBootstrap = false;
    }

    return CupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: _localizationService.user__profile_posts_exclude_communities,
      ),
      child: OBPrimaryColorContainer(
        child: OBHttpList<Community>(
          isSelectable: true,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          controller: _httpListController,
          listItemBuilder: _buildCommunityListItem,
          searchResultListItemBuilder: _buildCommunityListItem,
          selectedListItemBuilder: _buildCommunityListItem,
          listRefresher: _refreshJoinedCommunities,
          listOnScrollLoader: _loadMoreJoinedCommunities,
          listSearcher: _searchCommunities,
          selectionSubmitter: _excludeCommunities,
          onSelectionSubmitted: _onCommunitiesWereExcluded,
          resourceSingularName: _localizationService.community__community,
          resourcePluralName: _localizationService.community__communities,
        ),
      ),
    );
  }

  Widget _buildCommunityListItem(BuildContext context, Community community) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: OBCommunityTile(
        community,
        size: OBCommunityTileSize.small,
      ),
    );
  }

  Future<void> _excludeCommunities(List<Community> communities) {
    return Future.wait(communities
        .map((community) =>
            _userService.excludeCommunityFromProfilePosts(community))
        .toList());
  }

  void _onCommunitiesWereExcluded(List<Community> communities) {
    Navigator.pop(context, communities);
  }

  Future<List<Community>> _refreshJoinedCommunities() async {
    CommunitiesList joinedCommunities = await _userService.getJoinedCommunities(
        excludedFromProfilePosts: false);
    return joinedCommunities.communities ?? [];
  }

  Future<List<Community>> _loadMoreJoinedCommunities(
      List<Community> joinedCommunitiesList) async {
    var moreJoinedCommunities = (await _userService.getJoinedCommunities(
      offset: joinedCommunitiesList.length,
    ))
        .communities;

    return moreJoinedCommunities ?? [];
  }

  Future<List<Community>> _searchCommunities(String query) async {
    CommunitiesList results = await _userService
        .searchCommunitiesWithQuery(query, excludedFromProfilePosts: false);

    return results.communities ?? [];
  }
}
