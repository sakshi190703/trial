from django.apps import apps


def get_circle_model():
    return apps.get_model('kongo_circles.Circle')


def get_connection_model():
    return apps.get_model('kongo_connections.Connection')


def get_follow_model():
    return apps.get_model('kongo_follows.Follow')


def get_follow_request_model():
    return apps.get_model('kongo_follows.FollowRequest')


def get_post_model():
    return apps.get_model('kongo_posts.Post')


def get_top_post_model():
    return apps.get_model('kongo_posts.TopPost')


def get_trending_post_model():
    return apps.get_model('kongo_posts.TrendingPost')


def get_top_post_community_exclusion_model():
    return apps.get_model('kongo_posts.TopPostCommunityExclusion')


def get_profile_posts_community_exclusion_model():
    return apps.get_model('kongo_posts.ProfilePostsCommunityExclusion')


def get_post_media_model():
    return apps.get_model('kongo_posts.PostMedia')


def get_proxy_blacklist_domain_model():
    return apps.get_model('kongo_common.ProxyBlacklistedDomain')


def get_post_user_mention_model():
    return apps.get_model('kongo_posts.PostUserMention')


def get_post_comment_user_mention_model():
    return apps.get_model('kongo_posts.PostCommentUserMention')


def get_post_mute_model():
    return apps.get_model('kongo_posts.PostMute')


def get_post_comment_mute_model():
    return apps.get_model('kongo_posts.PostCommentMute')


def get_user_block_model():
    return apps.get_model('kongo_auth.UserBlock')


def get_list_model():
    return apps.get_model('kongo_lists.List')


def get_community_model():
    return apps.get_model('kongo_communities.Community')


def get_community_notifications_subscription_model():
    return apps.get_model('kongo_communities.CommunityNotificationsSubscription')


def get_community_invite_model():
    return apps.get_model('kongo_communities.CommunityInvite')


def get_community_log_model():
    return apps.get_model('kongo_communities.CommunityLog')


def get_post_comment_model():
    return apps.get_model('kongo_posts.PostComment')


def get_post_reaction_model():
    return apps.get_model('kongo_posts.PostReaction')


def get_post_comment_reaction_model():
    return apps.get_model('kongo_posts.PostCommentReaction')


def get_emoji_model():
    return apps.get_model('kongo_common.Emoji')


def get_emoji_group_model():
    return apps.get_model('kongo_common.EmojiGroup')


def get_user_invite_model():
    return apps.get_model('kongo_invitations.UserInvite')


def get_badge_model():
    return apps.get_model('kongo_common.Badge')


def get_language_model():
    return apps.get_model('kongo_common.Language')


def get_hashtag_model():
    return apps.get_model('kongo_hashtags.Hashtag')


def get_category_model():
    return apps.get_model('kongo_categories.Category')


def get_community_membership_model():
    return apps.get_model('kongo_communities.CommunityMembership')


def get_post_comment_notification_model():
    return apps.get_model('kongo_notifications.PostCommentNotification')


def get_post_user_mention_notification_model():
    return apps.get_model('kongo_notifications.PostUserMentionNotification')


def get_post_comment_user_mention_notification_model():
    return apps.get_model('kongo_notifications.PostCommentUserMentionNotification')


def get_post_comment_reply_notification_model():
    return apps.get_model('kongo_notifications.PostCommentReplyNotification')


def get_post_reaction_notification_model():
    return apps.get_model('kongo_notifications.PostReactionNotification')


def get_post_comment_reaction_notification_model():
    return apps.get_model('kongo_notifications.PostCommentReactionNotification')


def get_follow_notification_model():
    return apps.get_model('kongo_notifications.FollowNotification')


def get_follow_request_notification_model():
    return apps.get_model('kongo_notifications.FollowRequestNotification')


def get_follow_request_approved_notification_model():
    return apps.get_model('kongo_notifications.FollowRequestApprovedNotification')


def get_connection_request_notification_model():
    return apps.get_model('kongo_notifications.ConnectionRequestNotification')


def get_connection_confirmed_notification_model():
    return apps.get_model('kongo_notifications.ConnectionConfirmedNotification')


def get_community_invite_notification_model():
    return apps.get_model('kongo_notifications.CommunityInviteNotification')


def get_community_new_post_notification_model():
    return apps.get_model('kongo_notifications.CommunityNewPostNotification')


def get_user_new_post_notification_model():
    return apps.get_model('kongo_notifications.UserNewPostNotification')


def get_notification_model():
    return apps.get_model('kongo_notifications.Notification')


def get_device_model():
    return apps.get_model('kongo_devices.Device')


def get_user_model():
    return apps.get_model('kongo_auth.User')


def get_user_notifications_subscription_model():
    return apps.get_model('kongo_auth.UserNotificationsSubscription')


def get_moderated_object_model():
    return apps.get_model('kongo_moderation.ModeratedObject')


def get_moderation_report_model():
    return apps.get_model('kongo_moderation.ModerationReport')


def get_moderation_category_model():
    return apps.get_model('kongo_moderation.ModerationCategory')


def get_moderation_penalty_model():
    return apps.get_model('kongo_moderation.ModerationPenalty')
