import 'dart:async';

import 'package:Kootumb/models/follow_request.dart';
import 'package:Kootumb/models/follow_request_list.dart';
import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/services/user.dart';
import 'package:Kootumb/widgets/http_list.dart';
import 'package:Kootumb/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Kootumb/widgets/page_scaffold.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/widgets/theming/primary_color_container.dart';
import 'package:Kootumb/widgets/tiles/received_follow_request_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBFollowRequestsPage extends StatefulWidget {
  const OBFollowRequestsPage({Key? key}) : super(key: key);

  @override
  State<OBFollowRequestsPage> createState() {
    return OBFollowRequestsPageState();
  }
}

class OBFollowRequestsPageState extends State<OBFollowRequestsPage> {
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

    return OBCupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: _localizationService.user__follow_requests,
      ),
      child: OBPrimaryColorContainer(
        child: OBHttpList<FollowRequest>(
          controller: _httpListController,
          listItemBuilder: _buildFollowRequestListItem,
          listRefresher: _refreshFollowRequests,
          listOnScrollLoader: _loadMoreFollowRequests,
          resourceSingularName: _localizationService.user__follow_request,
          resourcePluralName: _localizationService.user__follow_requests,
        ),
      ),
    );
  }

  Widget _buildFollowRequestListItem(
      BuildContext context, FollowRequest followRequest) {
    return StreamBuilder(
      stream: followRequest.creator?.updateSubject,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        // In case the request was approved elsewhere, make sure we dont render it
        if ((snapshot.data != null &&
                snapshot.data!.isFollowed != null &&
                snapshot.data!.isFollowed!) ||
            (snapshot.data != null &&
                snapshot.data!.isPendingFollowRequestApproval != null &&
                !snapshot.data!.isPendingFollowRequestApproval!)) {
          return const SizedBox();
        }

        return OBReceivedFollowRequestTile(
          followRequest,
          onFollowRequestApproved: _removeFollowRequestFromList,
          onFollowRequestRejected: _removeFollowRequestFromList,
        );
      },
    );
  }

  void _removeFollowRequestFromList(FollowRequest followRequest) {
    _httpListController.removeListItem(followRequest);
  }

  Future<List<FollowRequest>> _refreshFollowRequests() async {
    FollowRequestList followRequests =
        await _userService.getReceivedFollowRequests();
    return followRequests.followRequests ?? [];
  }

  Future<List<FollowRequest>> _loadMoreFollowRequests(
      List<FollowRequest> followRequestsList) async {
    var lastFollowRequest = followRequestsList.last;
    var lastFollowRequestId = lastFollowRequest.id;
    var moreFollowRequests = (await _userService.getReceivedFollowRequests(
      maxId: lastFollowRequestId,
      count: 20,
    ))
        .followRequests;
    return moreFollowRequests ?? [];
  }
}
