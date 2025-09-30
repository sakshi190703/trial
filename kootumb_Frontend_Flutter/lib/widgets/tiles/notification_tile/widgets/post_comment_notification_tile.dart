import 'package:Kootumb/models/notifications/notification.dart';
import 'package:Kootumb/models/notifications/post_comment_notification.dart';
import 'package:Kootumb/models/post.dart';
import 'package:Kootumb/models/post_comment.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/avatars/avatar.dart';
import 'package:Kootumb/widgets/theming/secondary_text.dart';
import 'package:Kootumb/widgets/tiles/notification_tile/notification_tile_post_media_preview.dart';
import 'package:flutter/material.dart';

import 'notification_tile_skeleton.dart';
import 'notification_tile_title.dart';

class OBPostCommentNotificationTile extends StatelessWidget {
  final OBNotification notification;
  final PostCommentNotification postCommentNotification;
  static final double postImagePreviewSize = 40;
  final VoidCallback? onPressed;

  const OBPostCommentNotificationTile(
      {Key? key,
      required this.notification,
      required this.postCommentNotification,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    PostComment postComment = postCommentNotification.postComment!;
    Post post = postComment.post!;
    String postCommentText = postComment.text!;

    int postCreatorId = postCommentNotification.getPostCreatorId()!;
    KongoProviderState kongoProvider = KongoProvider.of(context);
    bool isOwnPostNotification =
        kongoProvider.userService.getLoggedInUser()?.id == postCreatorId;
    LocalizationService localizationService =
        KongoProvider.of(context).localizationService;

    Widget? postImagePreview;
    if (post.hasMediaThumbnail()) {
      postImagePreview = OBNotificationTilePostMediaPreview(
        post: post,
      );
    }

    var utilsService = kongoProvider.utilsService;

    navigateToCommenterProfile() {
      kongoProvider.navigationService.navigateToUserProfile(
          user: postComment.commenter!, context: context);
    }

    return OBNotificationTileSkeleton(
      onTap: () {
        if (onPressed != null) onPressed!();
        KongoProviderState kongoProvider = KongoProvider.of(context);

        kongoProvider.navigationService.navigateToPostCommentsLinked(
            postComment: postComment, context: context);
      },
      leading: OBAvatar(
        onPressed: navigateToCommenterProfile,
        size: OBAvatarSize.medium,
        avatarUrl: postComment.commenter!.getProfileAvatar(),
      ),
      title: OBNotificationTileTitle(
        onUsernamePressed: navigateToCommenterProfile,
        user: postComment.commenter,
        text: TextSpan(
            text: isOwnPostNotification
                ? localizationService
                    .notifications__comment_comment_notification_tile_user_commented(
                        postCommentText)
                : localizationService
                    .notifications__comment_comment_notification_tile_user_also_commented(
                        postCommentText)),
      ),
      trailing: postImagePreview,
      subtitle: OBSecondaryText(
          utilsService.timeAgo(notification.created!, localizationService)),
    );
  }
}
