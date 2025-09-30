import 'package:Kootumb/models/notifications/notification.dart';
import 'package:Kootumb/models/notifications/user_new_post_notification.dart';
import 'package:Kootumb/models/post.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/avatars/avatar.dart';
import 'package:Kootumb/widgets/theming/secondary_text.dart';
import 'package:Kootumb/widgets/tiles/notification_tile/notification_tile_post_media_preview.dart';
import 'package:flutter/material.dart';

import 'notification_tile_skeleton.dart';
import 'notification_tile_title.dart';

class OBUserNewPostNotificationTile extends StatelessWidget {
  final OBNotification notification;
  final UserNewPostNotification userNewPostNotification;
  static final double postImagePreviewSize = 40;
  final VoidCallback? onPressed;

  const OBUserNewPostNotificationTile(
      {Key? key,
      required this.notification,
      required this.userNewPostNotification,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Post post = userNewPostNotification.post!;

    Widget? postImagePreview;
    if (post.hasMediaThumbnail()) {
      postImagePreview = OBNotificationTilePostMediaPreview(
        post: post,
      );
    }
    KongoProviderState kongoProvider = KongoProvider.of(context);
    var utilsService = kongoProvider.utilsService;

    navigateToCreatorProfile() {
      kongoProvider.navigationService.navigateToUserProfile(
          user: userNewPostNotification.post!.creator!, context: context);
    }

    LocalizationService localizationService = kongoProvider.localizationService;

    onTileTapped() {
      if (onPressed != null) onPressed!();
      KongoProviderState kongoProvider = KongoProvider.of(context);
      kongoProvider.navigationService.navigateToPost(
          post: userNewPostNotification.post!, context: context);
    }

    return OBNotificationTileSkeleton(
      onTap: onTileTapped,
      leading: OBAvatar(
        onPressed: navigateToCreatorProfile,
        size: OBAvatarSize.medium,
        avatarUrl: userNewPostNotification.post!.creator!.getProfileAvatar(),
      ),
      title: OBNotificationTileTitle(
        onUsernamePressed: navigateToCreatorProfile,
        user: userNewPostNotification.post!.creator,
        text: TextSpan(
            text: localizationService.notifications__user_new_post_tile),
      ),
      trailing: postImagePreview,
      subtitle: OBSecondaryText(
          utilsService.timeAgo(notification.created!, localizationService)),
    );
  }
}
