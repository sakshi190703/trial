import 'package:Kootumb/models/notifications/notification.dart';
import 'package:Kootumb/models/notifications/post_comment_user_mention_notification.dart';
import 'package:Kootumb/models/post_comment.dart';
import 'package:Kootumb/models/post_comment_user_mention.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/avatars/avatar.dart';
import 'package:Kootumb/widgets/theming/actionable_smart_text.dart';
import 'package:Kootumb/widgets/theming/secondary_text.dart';
import 'package:flutter/material.dart';

import 'notification_tile_skeleton.dart';
import 'notification_tile_title.dart';

class OBPostCommentUserMentionNotificationTile extends StatelessWidget {
  final OBNotification notification;
  final PostCommentUserMentionNotification postCommentUserMentionNotification;
  static final double postCommentImagePreviewSize = 40;
  final VoidCallback? onPressed;

  const OBPostCommentUserMentionNotificationTile(
      {Key? key,
      required this.notification,
      required this.postCommentUserMentionNotification,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    PostCommentUserMention postCommentUserMention =
        postCommentUserMentionNotification.postCommentUserMention!;
    PostComment postComment = postCommentUserMention.postComment!;

    KongoProviderState kongoProvider = KongoProvider.of(context);
    var utilsService = kongoProvider.utilsService;

    navigateToMentionerProfile() {
      kongoProvider.navigationService.navigateToUserProfile(
          user: postCommentUserMention.postComment!.commenter!,
          context: context);
    }

    LocalizationService localizationService = kongoProvider.localizationService;

    String postCommentText = postComment.text!;
    return OBNotificationTileSkeleton(
      onTap: () {
        if (onPressed != null) onPressed!();
        KongoProviderState kongoProvider = KongoProvider.of(context);

        PostComment? parentComment = postComment.parentComment;
        if (parentComment != null) {
          kongoProvider.navigationService.navigateToPostCommentRepliesLinked(
              postComment: postComment,
              context: context,
              parentComment: parentComment);
        } else {
          kongoProvider.navigationService.navigateToPostCommentsLinked(
              postComment: postComment, context: context);
        }
      },
      leading: OBAvatar(
        onPressed: navigateToMentionerProfile,
        size: OBAvatarSize.medium,
        avatarUrl:
            postCommentUserMention.postComment!.commenter!.getProfileAvatar(),
      ),
      title: OBNotificationTileTitle(
        text: TextSpan(
            text: localizationService
                .notifications__mentioned_in_post_comment_tile(
                    postCommentText)),
        onUsernamePressed: navigateToMentionerProfile,
        user: postCommentUserMention.postComment!.commenter,
      ),
      subtitle: OBSecondaryText(
        utilsService.timeAgo(notification.created!, localizationService),
        size: OBTextSize.small,
      ),
    );
  }
}
