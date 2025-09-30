import 'package:Kootumb/models/post.dart';
import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/pages/home/bottom_sheets/post_actions.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/widgets/avatars/avatar.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/post/post.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:Kootumb/widgets/theming/secondary_text.dart';
import 'package:Kootumb/widgets/user_badge.dart';
import 'package:flutter/material.dart';

class OBUserPostHeader extends StatelessWidget {
  final Post _post;
  final OnPostDeleted onPostDeleted;
  final ValueChanged<Post>? onPostReported;
  final OBPostDisplayContext? displayContext;
  final bool hasActions;

  const OBUserPostHeader(this._post,
      {Key? key,
      required this.onPostDeleted,
      this.onPostReported,
      this.hasActions = true,
      this.displayContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var kongoProvider = KongoProvider.of(context);
    var navigationService = kongoProvider.navigationService;
    var bottomSheetService = kongoProvider.bottomSheetService;
    var utilsService = kongoProvider.utilsService;
    var localizationService = kongoProvider.localizationService;

    if (_post.creator == null) return const SizedBox();

    String subtitle = '@${_post.creator!.username}';

    if (_post.created != null) {
      subtitle =
          '$subtitle · ${utilsService.timeAgo(_post.created!, localizationService)}';
    }

    navigateToUserProfile() {
      navigationService.navigateToUserProfile(
          user: _post.creator!, context: context);
    }

    return ListTile(
        onTap: navigateToUserProfile,
        leading: StreamBuilder(
            stream: _post.creator!.updateSubject,
            initialData: _post.creator,
            builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
              User postCreator = snapshot.data!;

              return OBAvatar(
                size: OBAvatarSize.medium,
                avatarUrl: postCreator.getProfileAvatar(),
              );
            }),
        trailing: hasActions
            ? IconButton(
                icon: const OBIcon(OBIcons.moreVertical),
                onPressed: () {
                  bottomSheetService.showPostActions(
                      context: context,
                      post: _post,
                      onPostDeleted: onPostDeleted,
                      displayContext: displayContext!,
                      onPostReported: onPostReported);
                })
            : null,
        title: Row(
          children: <Widget>[
            Flexible(
              child: OBText(
                _post.creator!.getProfileName()!,
                style: TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              width: 3,
            ),
            _buildBadge()
          ],
        ),
        subtitle: OBSecondaryText(
          subtitle,
          style: TextStyle(fontSize: 12.0),
        ));
  }

  Widget _buildBadge() {
    User postCommenter = _post.creator!;

    if (postCommenter.hasProfileBadges()) {
      return OBUserBadge(
          badge: _post.creator!.getDisplayedProfileBadge(),
          size: OBUserBadgeSize.small);
    }

    return const SizedBox();
  }
}
