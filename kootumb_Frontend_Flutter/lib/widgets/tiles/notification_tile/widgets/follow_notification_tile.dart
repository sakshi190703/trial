import 'package:Kootumb/models/notifications/follow_notification.dart';
import 'package:Kootumb/models/notifications/notification.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/avatars/avatar.dart';
import 'package:Kootumb/widgets/theming/secondary_text.dart';
import 'package:flutter/material.dart';

import 'notification_tile_skeleton.dart';
import 'notification_tile_title.dart';

class OBFollowNotificationTile extends StatelessWidget {
  final OBNotification notification;
  final FollowNotification followNotification;
  final VoidCallback? onPressed;

  const OBFollowNotificationTile(
      {Key? key,
      required this.notification,
      required this.followNotification,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    KongoProviderState kongoProvider = KongoProvider.of(context);
    var utilsService = kongoProvider.utilsService;

    navigateToFollowerProfile() {
      if (onPressed != null) onPressed!();
      kongoProvider.navigationService.navigateToUserProfile(
          user: followNotification.follower!, context: context);
    }

    LocalizationService localizationService =
        KongoProvider.of(context).localizationService;

    return OBNotificationTileSkeleton(
      onTap: navigateToFollowerProfile,
      leading: OBAvatar(
        size: OBAvatarSize.medium,
        avatarUrl: followNotification.follower!.getProfileAvatar(),
      ),
      title: OBNotificationTileTitle(
        onUsernamePressed: navigateToFollowerProfile,
        user: followNotification.follower,
        text: TextSpan(
            text: localizationService.notifications__following_you_tile),
      ),
      subtitle: OBSecondaryText(
          utilsService.timeAgo(notification.created!, localizationService)),
    );
  }
}
