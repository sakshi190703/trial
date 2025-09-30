import 'package:Kootumb/models/notifications/connection_request_notification.dart';
import 'package:Kootumb/models/notifications/notification.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/avatars/avatar.dart';
import 'package:Kootumb/widgets/theming/secondary_text.dart';
import 'package:flutter/material.dart';

import 'notification_tile_skeleton.dart';
import 'notification_tile_title.dart';

class OBConnectionRequestNotificationTile extends StatelessWidget {
  final OBNotification notification;
  final ConnectionRequestNotification connectionRequestNotification;
  final VoidCallback? onPressed;

  const OBConnectionRequestNotificationTile(
      {Key? key,
      required this.notification,
      required this.connectionRequestNotification,
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
          user: connectionRequestNotification.connectionRequester!,
          context: context);
    }

    return OBNotificationTileSkeleton(
      onTap: navigateToRequesterProfile,
      leading: OBAvatar(
        size: OBAvatarSize.medium,
        avatarUrl: connectionRequestNotification.connectionRequester!
            .getProfileAvatar(),
      ),
      title: OBNotificationTileTitle(
          onUsernamePressed: navigateToRequesterProfile,
          user: connectionRequestNotification.connectionRequester,
          text: TextSpan(
            text: localizationService.notifications__connection_request_tile,
          )),
      subtitle: OBSecondaryText(
          utilsService.timeAgo(notification.created!, localizationService)),
    );
  }
}
