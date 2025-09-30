import 'package:Kootumb/models/notifications/notification.dart';
import 'package:Kootumb/models/notifications/post_user_mention_notification.dart';
import 'package:Kootumb/models/post.dart';
import 'package:Kootumb/models/post_user_mention.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/avatars/avatar.dart';
import 'package:Kootumb/widgets/theming/secondary_text.dart';
import 'package:Kootumb/widgets/tiles/notification_tile/notification_tile_post_media_preview.dart';
import 'package:flutter/material.dart';

import 'notification_tile_skeleton.dart';
import 'notification_tile_title.dart';

class OBPostUserMentionNotificationTile extends StatelessWidget {
  final OBNotification notification;
  final PostUserMentionNotification postUserMentionNotification;
  static final double postImagePreviewSize = 40;
  final VoidCallback? onPressed;

  const OBPostUserMentionNotificationTile(
      {Key? key,
      required this.notification,
      required this.postUserMentionNotification,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    PostUserMention? postUserMention =
        postUserMentionNotification.postUserMention;
    if (postUserMention == null) return const SizedBox();

    Post? post = postUserMention.post;
    if (post == null) return const SizedBox();

    Widget? postImagePreview;
    if (post.hasMediaThumbnail()) {
      postImagePreview = OBNotificationTilePostMediaPreview(
        post: post,
      );
    }
    KongoProviderState kongoProvider = KongoProvider.of(context);
    var utilsService = kongoProvider.utilsService;

    navigateToMentionerProfile() {
      final creator = postUserMention.post?.creator;
      if (creator != null) {
        kongoProvider.navigationService
            .navigateToUserProfile(user: creator, context: context);
      }
    }

    LocalizationService localizationService = kongoProvider.localizationService;

    onTileTapped() {
      if (onPressed != null) onPressed!();
      final post = postUserMention.post;
      if (post != null) {
        KongoProviderState kongoProvider = KongoProvider.of(context);
        kongoProvider.navigationService
            .navigateToPost(post: post, context: context);
      }
    }

    return OBNotificationTileSkeleton(
      onTap: onTileTapped,
      leading: OBAvatar(
        onPressed: navigateToMentionerProfile,
        size: OBAvatarSize.medium,
        avatarUrl: postUserMention.post?.creator?.getProfileAvatar(),
      ),
      title: OBNotificationTileTitle(
        onUsernamePressed: navigateToMentionerProfile,
        user: postUserMention.post?.creator,
        text: TextSpan(
            text: localizationService.notifications__mentioned_in_post_tile),
      ),
      trailing: postImagePreview,
      subtitle: OBSecondaryText(utilsService.timeAgo(
          notification.created ?? DateTime.now(), localizationService)),
    );
  }
}
