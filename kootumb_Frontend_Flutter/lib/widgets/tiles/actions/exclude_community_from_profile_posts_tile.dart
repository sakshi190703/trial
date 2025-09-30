import 'package:Kootumb/models/community.dart';
import 'package:Kootumb/models/post.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/bottom_sheet.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/services/toast.dart';
import 'package:Kootumb/services/user.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBExcludeCommunityFromProfilePostsTile extends StatefulWidget {
  final Post post;
  final ValueChanged<Community> onPostCommunityExcludedFromProfilePosts;

  const OBExcludeCommunityFromProfilePostsTile({
    Key? key,
    required this.post,
    required this.onPostCommunityExcludedFromProfilePosts,
  }) : super(key: key);

  @override
  OBExcludeCommunityFromProfilePostsTileState createState() {
    return OBExcludeCommunityFromProfilePostsTileState();
  }
}

class OBExcludeCommunityFromProfilePostsTileState
    extends State<OBExcludeCommunityFromProfilePostsTile> {
  late UserService _userService;
  late ToastService _toastService;
  late LocalizationService _localizationService;
  late BottomSheetService _bottomSheetService;

  @override
  Widget build(BuildContext context) {
    var kongoProvider = KongoProvider.of(context);
    _userService = kongoProvider.userService;
    _toastService = kongoProvider.toastService;
    _localizationService = kongoProvider.localizationService;
    _bottomSheetService = kongoProvider.bottomSheetService;

    return ListTile(
      leading: OBIcon(OBIcons.excludePostCommunity),
      title: OBText(
          _localizationService.post__exclude_community_from_profile_posts),
      onTap: _onWantsToExcludeCommunity,
    );
  }

  void _onWantsToExcludeCommunity() {
    _bottomSheetService.showConfirmAction(
        context: context,
        subtitle: _localizationService
            .post__exclude_community_from_profile_posts_confirmation,
        actionCompleter: (BuildContext context) async {
          await _excludePostCommunity();

          widget
              .onPostCommunityExcludedFromProfilePosts(widget.post.community!);
          _toastService.success(
              message: _localizationService
                  .post__exclude_community_from_profile_posts_success,
              context: context);
        });
  }

  Future _excludePostCommunity() async {
    return _userService
        .excludeCommunityFromProfilePosts(widget.post.community!);
  }
}
