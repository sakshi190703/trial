import 'dart:async';

import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/models/users_list.dart';
import 'package:Kootumb/services/navigation_service.dart';
import 'package:Kootumb/services/toast.dart';
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

class OBBlockedUsersPage extends StatefulWidget {
  const OBBlockedUsersPage({Key? key}) : super(key: key);

  @override
  State<OBBlockedUsersPage> createState() {
    return OBBlockedUsersPageState();
  }
}

class OBBlockedUsersPageState extends State<OBBlockedUsersPage> {
  late UserService _userService;
  late NavigationService _navigationService;
  late ToastService _toastService;

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
      _toastService = provider.toastService;
      _needsBootstrap = false;
    }

    return OBCupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: 'Blocked users',
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
          listItemBuilder: _buildBlockedUserListItem,
          searchResultListItemBuilder: _buildBlockedUserListItem,
          listRefresher: _refreshBlockedUsers,
          listOnScrollLoader: _loadMoreBlockedUsers,
          listSearcher: _searchBlockedUsers,
          resourceSingularName: 'blocked user',
          resourcePluralName: 'blocked users',
        ),
      ),
    );
  }

  Widget _buildBlockedUserListItem(BuildContext context, User user) {
    return OBUserTile(
      user,
      onUserTilePressed: _onBlockedUserListItemPressed,
      onUserTileDeleted: _onBlockedUserListItemDeleted,
    );
  }

  void _onBlockedUserListItemPressed(User blockedUser) {
    _navigationService.navigateToUserProfile(
        user: blockedUser, context: context);
  }

  void _onBlockedUserListItemDeleted(User blockedUser) async {
    try {
      await _userService.unblockUser(blockedUser);
      _httpListController.removeListItem(blockedUser);
    } catch (error) {
      _onError(error);
    }
  }

  void _onError(error) async {
    if (error is HttpieConnectionRefusedError) {
      _toastService.error(
          message: error.toHumanReadableMessage(), context: context);
    } else if (error is HttpieRequestError) {
      String? errorMessage = await error.toHumanReadableMessage();
      _toastService.error(
          message: errorMessage ?? 'Unknown error', context: context);
    } else {
      _toastService.error(message: 'Unknown error', context: context);
      throw error;
    }
  }

  Future<List<User>> _refreshBlockedUsers() async {
    UsersList blockedUsers = await _userService.getBlockedUsers();
    return blockedUsers.users ?? [];
  }

  Future<List<User>> _loadMoreBlockedUsers(List<User> blockedUsersList) async {
    var lastBlockedUser = blockedUsersList.last;
    var lastBlockedUserId = lastBlockedUser.id;
    var moreBlockedUsers = (await _userService.getBlockedUsers(
      maxId: lastBlockedUserId,
      count: 10,
    ))
        .users;
    return moreBlockedUsers ?? [];
  }

  Future<List<User>> _searchBlockedUsers(String query) async {
    UsersList results = await _userService.searchBlockedUsers(query: query);

    return results.users ?? [];
  }
}

typedef OnWantsToCreateBlockedUser = Future<User> Function();
typedef OnWantsToEditBlockedUser = Future<User> Function(User blockedUser);
typedef OnWantsToSeeBlockedUser = void Function(User blockedUser);
