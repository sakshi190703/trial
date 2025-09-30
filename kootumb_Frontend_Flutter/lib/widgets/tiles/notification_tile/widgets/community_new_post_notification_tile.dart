import 'package:Kootumb/models/notifications/community_new_post_notification.dart';
import 'package:Kootumb/models/notifications/notification.dart';
import 'package:Kootumb/models/post.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/avatars/community_avatar.dart';
import 'package:Kootumb/widgets/theming/secondary_text.dart';
import 'package:Kootumb/widgets/tiles/notification_tile/notification_tile_post_media_preview.dart';
import 'package:flutter/material.dart';

import 'notification_tile_skeleton.dart';
import 'notification_tile_title.dart';

class OBCommunityNewPostNotificationTile extends StatelessWidget {
  final OBNotification notification;
  final CommunityNewPostNotification communityNewPostNotification;
  static final double postImagePreviewSize = 40;
  final VoidCallback? onPressed;

  const OBCommunityNewPostNotificationTile(
      {Key? key,
      required this.notification,
      required this.communityNewPostNotification,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Post post = communityNewPostNotification.post!;

    Widget? postImagePreview;
    if (post.hasMediaThumbnail()) {
      postImagePreview = Padding(
          padding: const EdgeInsets.only(left: 10),
          child: OBNotificationTilePostMediaPreview(
            post: post,
          ));
    }
    KongoProviderState kongoProvider = KongoProvider.of(context);
    var utilsService = kongoProvider.utilsService;
    LocalizationService localizationService = kongoProvider.localizationService;

    navigateToCommunity() {
      kongoProvider.navigationService
          .navigateToCommunity(community: post.community!, context: context);
    }

    return OBNotificationTileSkeleton(
      onTap: () {
        if (onPressed != null) onPressed!();
        KongoProviderState kongoProvider = KongoProvider.of(context);
        kongoProvider.navigationService
            .navigateToPost(post: post, context: context);
      },
      leading: OBCommunityAvatar(
        onPressed: navigateToCommunity,
        size: OBAvatarSize.medium,
        community: post.community!,
      ),
      title: OBNotificationTileTitle(
        text: TextSpan(
            text: localizationService
                .notifications__community_new_post_tile(post.community!.name!)),
      ),
      subtitle: OBSecondaryText(
          utilsService.timeAgo(notification.created!, localizationService)),
      trailing: postImagePreview,
    );
  }
}
