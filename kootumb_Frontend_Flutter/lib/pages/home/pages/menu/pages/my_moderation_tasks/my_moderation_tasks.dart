import 'dart:async';

import 'package:Kootumb/models/communities_list.dart';
import 'package:Kootumb/models/community.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/services/navigation_service.dart';
import 'package:Kootumb/widgets/badges/badge.dart';
import 'package:Kootumb/widgets/http_list.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/icon_button.dart';
import 'package:Kootumb/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Kootumb/widgets/page_scaffold.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/user.dart';
import 'package:Kootumb/widgets/theming/primary_color_container.dart';
import 'package:Kootumb/widgets/tiles/community_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBMyModerationTasksPage extends StatefulWidget {
  const OBMyModerationTasksPage({Key? key}) : super(key: key);

  @override
  State<OBMyModerationTasksPage> createState() {
    return OBMyModerationTasksPageState();
  }
}

class OBMyModerationTasksPageState extends State<OBMyModerationTasksPage> {
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
        title: _localizationService.moderation__my_moderation_tasks_title,
        leading: OBIconButton(
          OBIcons.close,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      child: OBPrimaryColorContainer(
        child: OBHttpList<Community>(
          padding: EdgeInsets.all(15),
          controller: _httpListController,
          listItemBuilder: _buildPendingModeratedObjectsCommunityListItem,
          listRefresher: _refreshPendingModeratedObjectsCommunities,
          listOnScrollLoader: _loadMorePendingModeratedObjectsCommunities,
          resourceSingularName: _localizationService
              .moderation__pending_moderation_tasks_singular,
          resourcePluralName:
              _localizationService.moderation__pending_moderation_tasks_plural,
        ),
      ),
    );
  }

  Widget _buildPendingModeratedObjectsCommunityListItem(
      BuildContext context, Community community) {
    return GestureDetector(
      onTap: () =>
          _onPendingModeratedObjectsCommunityListItemPressed(community),
      child: Row(
        children: <Widget>[
          Expanded(
            child: OBCommunityTile(community),
          ),
          SizedBox(
            width: 20,
          ),
          OBBadge(
            size: 25,
            count: community.pendingModeratedObjectsCount,
          )
        ],
      ),
    );
  }

  void _onPendingModeratedObjectsCommunityListItemPressed(Community community) {
    _navigationService.navigateToCommunityModeratedObjects(
        community: community, context: context);
  }

  Future<List<Community>> _refreshPendingModeratedObjectsCommunities() async {
    CommunitiesList pendingModeratedObjectsCommunities =
        await _userService.getPendingModeratedObjectsCommunities();
    return pendingModeratedObjectsCommunities.communities ?? [];
  }

  Future<List<Community>> _loadMorePendingModeratedObjectsCommunities(
      List<Community> pendingModeratedObjectsCommunitiesList) async {
    var lastPendingModeratedObjectsCommunity =
        pendingModeratedObjectsCommunitiesList.last;
    var lastPendingModeratedObjectsCommunityId =
        lastPendingModeratedObjectsCommunity.id;
    var morePendingModeratedObjectsCommunities =
        (await _userService.getPendingModeratedObjectsCommunities(
      maxId: lastPendingModeratedObjectsCommunityId,
      count: 10,
    ))
            .communities;
    return morePendingModeratedObjectsCommunities ?? [];
  }
}
