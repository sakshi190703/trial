import 'package:Kootumb/models/notifications/connection_confirmed_notification.dart';
import 'package:Kootumb/models/notifications/notification.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/avatars/avatar.dart';
import 'package:Kootumb/widgets/theming/secondary_text.dart';
import 'package:flutter/material.dart';

import 'notification_tile_skeleton.dart';
import 'notification_tile_title.dart';

class OBConnectionConfirmedNotificationTile extends StatelessWidget {
  final OBNotification notification;
  final ConnectionConfirmedNotification connectionConfirmedNotification;
  final VoidCallback? onPressed;

  const OBConnectionConfirmedNotificationTile(
      {Key? key,
      required this.notification,
      required this.connectionConfirmedNotification,
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
          user: connectionConfirmedNotification.connectionConfirmator!,
          context: context);
    }

    LocalizationService localizationService =
        KongoProvider.of(context).localizationService;

    return OBNotificationTileSkeleton(
      onTap: navigateToConfirmatorProfile,
      leading: OBAvatar(
        size: OBAvatarSize.medium,
        avatarUrl: connectionConfirmedNotification.connectionConfirmator!
            .getProfileAvatar(),
      ),
      title: OBNotificationTileTitle(
        onUsernamePressed: navigateToConfirmatorProfile,
        user: connectionConfirmedNotification.connectionConfirmator,
        text: TextSpan(
            text: localizationService
                .notifications__accepted_connection_request_tile),
      ),
      subtitle: OBSecondaryText(
          utilsService.timeAgo(notification.created!, localizationService)),
    );
  }
}
