import 'package:Kootumb/models/notifications/follow_request_notification.dart';
import 'package:Kootumb/models/notifications/notification.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/avatars/avatar.dart';
import 'package:Kootumb/widgets/theming/secondary_text.dart';
import 'package:flutter/material.dart';

import 'notification_tile_skeleton.dart';
import 'notification_tile_title.dart';

class OBFollowRequestNotificationTile extends StatelessWidget {
  final OBNotification notification;
  final FollowRequestNotification followRequestNotification;
  final VoidCallback? onPressed;

  const OBFollowRequestNotificationTile(
      {Key? key,
      required this.notification,
      required this.followRequestNotification,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    KongoProviderState kongoProvider = KongoProvider.of(context);
    var utilsService = kongoProvider.utilsService;
    LocalizationService localizationService = kongoProvider.localizationService;

    navigateToRequesterProfile() {
      if (onPressed != null) onPressed!();
      KongoProviderState kongoProvider = KongoProvider.of(context);

      kongoProvider.navigationService.navigateToUserProfile(
          user: followRequestNotification.followRequest!.creator!,
          context: context);
    }

    return OBNotificationTileSkeleton(
      onTap: navigateToRequesterProfile,
      leading: OBAvatar(
        size: OBAvatarSize.medium,
        avatarUrl: followRequestNotification.followRequest!.creator!
            .getProfileAvatar(),
      ),
      title: OBNotificationTileTitle(
          onUsernamePressed: navigateToRequesterProfile,
          user: followRequestNotification.followRequest!.creator,
          text: TextSpan(
            text: localizationService.notifications__follow_request_tile,
          )),
      subtitle: OBSecondaryText(
          utilsService.timeAgo(notification.created!, localizationService)),
    );
  }
}
