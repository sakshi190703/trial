import 'package:Kootumb/models/notifications/follow_request_approved_notification.dart';
import 'package:Kootumb/models/notifications/notification.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/avatars/avatar.dart';
import 'package:Kootumb/widgets/theming/secondary_text.dart';
import 'package:flutter/material.dart';

import 'notification_tile_skeleton.dart';
import 'notification_tile_title.dart';

class OBFollowRequestApprovedNotificationTile extends StatelessWidget {
  final OBNotification notification;
  final FollowRequestApprovedNotification followRequestApprovedNotification;
  final VoidCallback? onPressed;

  const OBFollowRequestApprovedNotificationTile(
      {Key? key,
      required this.notification,
      required this.followRequestApprovedNotification,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    KongoProviderState kongoProvider = KongoProvider.of(context);
    var utilsService = kongoProvider.utilsService;

    navigateToConfirmatorProfile() {
      if (onPressed != null) onPressed!();
      KongoProviderState kongoProvider = KongoProvider.of(context);
      kongoProvider.navigationService.navigateToUserProfile(
          user: followRequestApprovedNotification.follow!.followedUser!,
          context: context);
    }

    LocalizationService localizationService =
        KongoProvider.of(context).localizationService;

    return OBNotificationTileSkeleton(
      onTap: navigateToConfirmatorProfile,
      leading: OBAvatar(
        size: OBAvatarSize.medium,
        avatarUrl: followRequestApprovedNotification.follow!.followedUser!
            .getProfileAvatar(),
      ),
      title: OBNotificationTileTitle(
        onUsernamePressed: navigateToConfirmatorProfile,
        user: followRequestApprovedNotification.follow!.followedUser,
        text: TextSpan(
            text: localizationService
                .notifications__approved_follow_request_tile),
      ),
      subtitle: OBSecondaryText(
          utilsService.timeAgo(notification.created!, localizationService)),
    );
  }
}
