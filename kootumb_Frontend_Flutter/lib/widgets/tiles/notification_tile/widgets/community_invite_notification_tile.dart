import 'package:Kootumb/models/community.dart';
import 'package:Kootumb/models/community_invite.dart';
import 'package:Kootumb/models/notifications/community_invite_notification.dart';
import 'package:Kootumb/models/notifications/notification.dart';
import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/avatars/community_avatar.dart';
import 'package:Kootumb/widgets/theming/secondary_text.dart';
import 'package:flutter/material.dart';

import 'notification_tile_skeleton.dart';
import 'notification_tile_title.dart';

class OBCommunityInviteNotificationTile extends StatelessWidget {
  final OBNotification notification;
  final CommunityInviteNotification communityInviteNotification;
  final VoidCallback? onPressed;
  static final double postImagePreviewSize = 40;

  const OBCommunityInviteNotificationTile(
      {Key? key,
      required this.notification,
      required this.communityInviteNotification,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    CommunityInvite communityInvite =
        communityInviteNotification.communityInvite!;
    User inviteCreator = communityInvite.creator!;
    Community community = communityInvite.community!;

    String communityName = community.name!;

    KongoProviderState kongoProvider = KongoProvider.of(context);
    var utilsService = kongoProvider.utilsService;

    navigateToInviteCreatorProfile() {
      kongoProvider.navigationService
          .navigateToUserProfile(user: inviteCreator, context: context);
    }

    LocalizationService localizationService = kongoProvider.localizationService;

    return OBNotificationTileSkeleton(
      onTap: () {
        if (onPressed != null) onPressed!();
        KongoProviderState kongoProvider = KongoProvider.of(context);

        kongoProvider.navigationService
            .navigateToCommunity(community: community, context: context);
      },
      leading: OBAvatar(
        onPressed: navigateToInviteCreatorProfile,
        size: OBAvatarSize.medium,
        avatarUrl: inviteCreator.getProfileAvatar(),
      ),
      title: OBNotificationTileTitle(
        user: inviteCreator,
        onUsernamePressed: navigateToInviteCreatorProfile,
        text: TextSpan(
            text: localizationService
                .notifications__user_community_invite_tile(communityName)),
      ),
      trailing: OBCommunityAvatar(
        community: community,
        size: OBAvatarSize.medium,
      ),
      subtitle: OBSecondaryText(
          utilsService.timeAgo(notification.created!, localizationService)),
    );
  }
}
