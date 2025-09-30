import 'package:Kootumb/models/badge.dart';
import 'package:Kootumb/models/circle.dart';
import 'package:Kootumb/models/circles_list.dart';
import 'package:Kootumb/models/community.dart';
import 'package:Kootumb/models/community_invite.dart';
import 'package:Kootumb/models/community_invite_list.dart';
import 'package:Kootumb/models/community_membership.dart';
import 'package:Kootumb/models/community_membership_list.dart';
import 'package:Kootumb/models/follows_lists_list.dart';
import 'package:Kootumb/models/language.dart';
import 'package:Kootumb/models/post.dart';
import 'package:Kootumb/models/post_comment.dart';
import 'package:Kootumb/models/updatable_model.dart';
import 'package:Kootumb/models/user_notifications_settings.dart';
import 'package:Kootumb/models/user_profile.dart';
import 'package:dcache/dcache.dart';

import 'follows_list.dart';

class User extends UpdatableModel<User> {
  @override
  int? id;
  String? uuid;
  int? connectionsCircleId;
  String? email;
  String? username;
  Language? language;
  UserVisibility? visibility;
  UserProfile? profile;
  DateTime? dateJoined;
  UserNotificationsSettings? notificationsSettings;
  int? followersCount;
  int? followingCount;
  int? unreadNotificationsCount;
  int? postsCount;
  int? inviteCount;
  int? pendingCommunitiesModeratedObjectsCount;
  int? activeModerationPenaltiesCount;
  // bool? areGuidelinesAccepted;
  bool? areNewPostNotificationsEnabled;
  bool? isFollowing;
  bool? isFollowed;
  bool? isFollowRequested;
  bool? isConnected;
  bool? isReported;
  bool? isBlocked;
  bool? isGlobalModerator;
  bool? isFullyConnected;
  bool? isPendingConnectionConfirmation;
  bool? isPendingFollowRequestApproval;
  bool? isMemberOfCommunities;
  CirclesList? connectedCircles;
  FollowsListsList? followLists;
  CommunityMembershipList? communitiesMemberships;
  CommunityInviteList? communitiesInvites;

  static final navigationUsersFactory = UserFactory(
    cache: LfuCache<int, User>(storage: UpdatableModelSimpleStorage(size: 100)),
  );
  static final sessionUsersFactory = UserFactory(
    cache: SimpleCache<int, User>(
      storage: UpdatableModelSimpleStorage(size: 10),
    ),
  );

  static final maxSessionUsersFactory = UserFactory(
    cache: SimpleCache<int, User>(
      storage: UpdatableModelSimpleStorage(
        size: UpdatableModelSimpleStorage.MAX_INT,
      ),
    ),
  );

  factory User.fromJson(
    Map<String, dynamic> json, {
    bool storeInSessionCache = false,
    bool storeInMaxSessionCache = false,
  }) {
    int userId = json['id'];

    User? user = maxSessionUsersFactory.getItemWithIdFromCache(userId) ??
        navigationUsersFactory.getItemWithIdFromCache(userId) ??
        sessionUsersFactory.getItemWithIdFromCache(userId);
    // user.update(json);
    if (user != null) {
      user.updateFromJson(json);
      return user;
    }
    return storeInMaxSessionCache
        ? maxSessionUsersFactory.fromJson(json)
        : storeInSessionCache
            ? sessionUsersFactory.fromJson(json)
            : navigationUsersFactory.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'date_joined': dateJoined?.toString(),
      'connections_circle_id': connectionsCircleId,
      'email': email,
      'username': username,
      'language': language?.toJson(),
      'profile': profile?.toJson(),
      'visibility': visibility?.code,
      'notifications_settings': notificationsSettings?.toJson(),
      'followers_count': followersCount,
      'following_count': followingCount,
      'unread_notifications_count': unreadNotificationsCount,
      'posts_count': postsCount,
      'invite_count': inviteCount,
      'pending_communities_moderated_objects_count':
          pendingCommunitiesModeratedObjectsCount,
      'active_moderation_penalties_count': activeModerationPenaltiesCount,
      // 'are_guidelines_accepted': areGuidelinesAccepted,
      'are_new_post_notifications_enabled': areNewPostNotificationsEnabled,
      'is_following': isFollowing,
      'is_followed': isFollowed,
      'is_follow_requested': isFollowRequested,
      'is_connected': isConnected,
      'is_reported': isReported,
      'is_blocked': isBlocked,
      'is_global_moderator': isGlobalModerator,
      'is_fully_connected': isFullyConnected,
      'is_pending_connection_confirmation': isPendingConnectionConfirmation,
      'is_pending_follow_request_approval': isPendingFollowRequestApproval,
      'is_member_of_communities': isMemberOfCommunities,
      'connected_circles': connectedCircles?.circles
          ?.map((Circle circle) => circle.toJson())
          .toList(),
      'follow_lists': followLists?.lists
          ?.map((FollowsList followList) => followList.toJson())
          .toList(),
      'communities_memberships': communitiesMemberships?.communityMemberships
          ?.map((CommunityMembership membership) => membership.toJson())
          .toList(),
      'communities_invites': communitiesInvites?.communityInvites
          ?.map((CommunityInvite invite) => invite.toJson())
          .toList(),
    };
  }

  static void clearNavigationCache() {
    navigationUsersFactory.clearCache();
  }

  static void clearSessionCache() {
    sessionUsersFactory.clearCache();
  }

  static void clearMaxSessionCache() {
    maxSessionUsersFactory.clearCache();
  }

  User({
    this.id,
    this.uuid,
    this.dateJoined,
    this.connectionsCircleId,
    this.username,
    this.visibility,
    this.email,
    this.profile,
    this.language,
    this.notificationsSettings,
    this.followersCount,
    this.followingCount,
    this.unreadNotificationsCount,
    this.postsCount,
    this.inviteCount,
    this.areNewPostNotificationsEnabled,
    this.isFollowing,
    this.isFollowed,
    this.isFollowRequested,
    this.isBlocked,
    this.isGlobalModerator,
    this.isConnected,
    this.isReported,
    this.isFullyConnected,
    this.isMemberOfCommunities,
    this.isPendingConnectionConfirmation,
    this.isPendingFollowRequestApproval,
    this.connectedCircles,
    this.followLists,
    this.communitiesMemberships,
    this.communitiesInvites,
    this.activeModerationPenaltiesCount,
    this.pendingCommunitiesModeratedObjectsCount,
    // this.areGuidelinesAccepted,
  });

  @override
  void updateFromJson(Map json) {
    if (json.containsKey('username')) username = json['username'];
    if (json.containsKey('uuid')) uuid = json['uuid'];
    if (json.containsKey('date_joined')) {
      dateJoined = navigationUsersFactory.parseDateJoined(json['date_joined']);
    }
    // if (json.containsKey('are_guidelines_accepted')) {
    //   areGuidelinesAccepted = json['are_guidelines_accepted'];
    // }
    if (json.containsKey('email')) email = json['email'];
    if (json.containsKey('profile')) {
      if (profile != null) {
        profile!.updateFromJson(json['profile']);
      } else {
        profile = navigationUsersFactory.parseUserProfile(json['profile']);
      }
    }
    if (json.containsKey('language')) {
      language = navigationUsersFactory.parseLanguage(json['language']);
    }
    if (json.containsKey('notifications_settings')) {
      if (notificationsSettings != null) {
        notificationsSettings!.updateFromJson(json['notifications_settings']);
      } else {
        notificationsSettings = navigationUsersFactory
            .parseUserNotificationsSettings(json['notifications_settings']);
      }
    }
    if (json.containsKey('followers_count')) {
      followersCount = json['followers_count'];
    }
    if (json.containsKey('pending_communities_moderated_objects_count')) {
      pendingCommunitiesModeratedObjectsCount =
          json['pending_communities_moderated_objects_count'];
    }
    if (json.containsKey('active_moderation_penalties_count')) {
      activeModerationPenaltiesCount =
          json['active_moderation_penalties_count'];
    }
    if (json.containsKey('following_count')) {
      followingCount = json['following_count'];
    }
    if (json.containsKey('unread_notifications_count')) {
      unreadNotificationsCount = json['unread_notifications_count'];
    }
    if (json.containsKey('posts_count')) postsCount = json['posts_count'];
    if (json.containsKey('invite_count')) inviteCount = json['invite_count'];
    if (json.containsKey('are_new_post_notifications_enabled')) {
      areNewPostNotificationsEnabled =
          json['are_new_post_notifications_enabled'];
    }
    if (json.containsKey('is_following')) isFollowing = json['is_following'];
    if (json.containsKey('is_followed')) isFollowed = json['is_followed'];
    if (json.containsKey('is_follow_requested')) {
      isFollowRequested = json['is_follow_requested'];
    }
    if (json.containsKey('is_connected')) isConnected = json['is_connected'];
    if (json.containsKey('is_global_moderator')) {
      isGlobalModerator = json['is_global_moderator'];
    }
    if (json.containsKey('is_blocked')) isBlocked = json['is_blocked'];
    if (json.containsKey('is_reported')) isReported = json['is_reported'];
    if (json.containsKey('connections_circle_id')) {
      connectionsCircleId = json['connections_circle_id'];
    }
    if (json.containsKey('is_fully_connected')) {
      isFullyConnected = json['is_fully_connected'];
    }
    if (json.containsKey('is_pending_connection_confirmation')) {
      isPendingConnectionConfirmation =
          json['is_pending_connection_confirmation'];
    }

    if (json.containsKey('is_pending_follow_request_approval')) {
      isPendingFollowRequestApproval =
          json['is_pending_follow_request_approval'];
    }
    if (json.containsKey('connected_circles')) {
      connectedCircles = navigationUsersFactory.parseCircles(
        json['connected_circles'],
      );
    }
    if (json.containsKey('is_member_of_communities')) {
      isMemberOfCommunities = json['is_member_of_communities'];
    }
    if (json.containsKey('follow_lists')) {
      followLists = navigationUsersFactory.parseFollowsLists(
        json['follow_lists'],
      );
    }
    if (json.containsKey('communities_memberships')) {
      communitiesMemberships = navigationUsersFactory.parseMemberships(
        json['communities_memberships'],
      );
    }
    if (json.containsKey('communities_invites')) {
      communitiesInvites = navigationUsersFactory.parseInvites(
        json['communities_invites'],
      );
    }

    if (json.containsKey('visibility')) {
      visibility = UserVisibility.parse(json['visibility']);
    }
  }

  String? getEmail() {
    return email;
  }

  bool hasProfileLocation() {
    return profile?.hasLocation() ?? false;
  }

  bool hasProfileUrl() {
    return profile?.hasUrl() ?? false;
  }

  bool hasAge() {
    return dateJoined != null;
  }

  bool hasProfileAvatar() {
    return profile?.avatar != null;
  }

  bool hasProfileCover() {
    return profile?.cover != null;
  }

  String? getProfileAvatar() {
    return profile?.avatar;
  }

  String? getProfileName() {
    return profile?.name;
  }

  String? getProfileCover() {
    return profile?.cover;
  }

  String? getProfileBio() {
    return profile?.bio;
  }

  bool getProfileFollowersCountVisible() {
    return profile?.followersCountVisible ?? false;
  }

  bool getProfileCommunityPostsVisible() {
    return profile?.communityPostsVisible ?? false;
  }

  String? getProfileUrl() {
    return profile?.url;
  }

  String? getProfileLocation() {
    return profile?.location;
  }

  List<Badge>? getProfileBadges() {
    return profile?.badges;
  }

  Badge? getDisplayedProfileBadge() {
    return getProfileBadges()?.first;
  }

  bool hasProfileBadges() {
    return profile != null &&
        profile!.badges != null &&
        profile!.badges!.isNotEmpty;
  }

  bool hasLanguage() {
    return language != null;
  }

  bool isConnectionsCircle(Circle circle) {
    return connectionsCircleId != null && connectionsCircleId == circle.id;
  }

  bool hasFollowLists() {
    return followLists != null && followLists!.lists!.isNotEmpty;
  }

  bool isAdministratorOfCommunity(Community community) {
    CommunityMembership? membership = getMembershipForCommunity(community);
    return membership?.isAdministrator ?? false;
  }

  bool isModeratorOfCommunity(Community community) {
    CommunityMembership? membership = getMembershipForCommunity(community);
    return membership?.isModerator ?? false;
  }

  bool isMemberOfCommunity(Community community) {
    return getMembershipForCommunity(community) != null;
  }

  CommunityMembership? getMembershipForCommunity(Community community) {
    if (communitiesMemberships == null) return null;

    int? membershipIndex = communitiesMemberships?.communityMemberships
        ?.indexWhere((CommunityMembership communityMembership) {
      return communityMembership.userId == id &&
          communityMembership.communityId == community.id;
    });

    if (membershipIndex! < 0) return null;

    return communitiesMemberships?.communityMemberships?[membershipIndex];
  }

  bool isInvitedToCommunity(Community community) {
    CommunityInvite? invite = getInviteForCommunity(community);
    return invite != null;
  }

  CommunityInvite? getInviteForCommunity(Community community) {
    if (communitiesInvites == null) return null;

    int? inviteIndex = communitiesInvites?.communityInvites?.indexWhere((
      CommunityInvite communityInvite,
    ) {
      return communityInvite.communityId == community.id;
    });

    if (inviteIndex == null || inviteIndex < 0) return null;

    return communitiesInvites?.communityInvites?[inviteIndex];
  }

  bool hasUnreadNotifications() {
    return unreadNotificationsCount != null && unreadNotificationsCount! > 0;
  }

  void resetUnreadNotificationsCount() {
    unreadNotificationsCount = 0;
    notifyUpdate();
  }

  void incrementUnreadNotificationsCount() {
    if (unreadNotificationsCount != null) {
      unreadNotificationsCount = unreadNotificationsCount! + 1;
      notifyUpdate();
    }
  }

  void incrementFollowersCount() {
    if (followersCount != null) {
      followersCount = followersCount! + 1;
      notifyUpdate();
    }
  }

  void decrementFollowersCount() {
    if (followersCount != null && followersCount! > 0) {
      followersCount = followersCount! + 1;
      notifyUpdate();
    }
  }

  bool hasPendingCommunitiesModeratedObjects() {
    return pendingCommunitiesModeratedObjectsCount != null &&
        pendingCommunitiesModeratedObjectsCount! > 0;
  }

  bool hasActiveModerationPenaltiesCount() {
    return activeModerationPenaltiesCount != null &&
        activeModerationPenaltiesCount! > 0;
  }

  void setIsReported(isReported) {
    this.isReported = isReported;
    notifyUpdate();
  }

  void setIsPendingFollowRequestApproval(isPendingFollowRequestApproval) {
    this.isPendingFollowRequestApproval = isPendingFollowRequestApproval;
    notifyUpdate();
  }

  void setIsFollowing(isFollowing) {
    this.isFollowing = isFollowing;
    notifyUpdate();
  }

  void setIsFollowRequested(isFollowRequested) {
    this.isFollowRequested = isFollowRequested;
    notifyUpdate();
  }

  void setIsFollowed(isFollowed) {
    this.isFollowed = isFollowed;
    notifyUpdate();
  }

  bool canDisableOrEnableCommentsForPost(Post post) {
    User loggedInUser = this;
    bool canDisableOrEnableComments = false;

    if (post.hasCommunity()) {
      Community? postCommunity = post.community;

      if (postCommunity == null ||
          postCommunity.isAdministrator(loggedInUser) ||
          postCommunity.isModerator(loggedInUser)) {
        canDisableOrEnableComments = true;
      }
    }
    return canDisableOrEnableComments;
  }

  bool canCloseOrOpenPost(Post post) {
    User loggedInUser = this;
    bool canCloseOrOpenPost = false;

    if (post.hasCommunity()) {
      Community? postCommunity = post.community;

      if (postCommunity == null ||
          postCommunity.isAdministrator(loggedInUser) ||
          postCommunity.isModerator(loggedInUser)) {
        canCloseOrOpenPost = true;
      }
    }
    return canCloseOrOpenPost;
  }

  bool canCloseOrOpenPostsInCommunity(Community community) {
    User loggedInUser = this;
    bool canCloseOrOpenPost = false;

    if (community.isAdministrator(loggedInUser) ||
        community.isModerator(loggedInUser)) {
      canCloseOrOpenPost = true;
    }

    return canCloseOrOpenPost;
  }

  bool canBanOrUnbanUsersInCommunity(Community community) {
    User loggedInUser = this;
    bool canBanOrUnban = false;

    if (community.isAdministrator(loggedInUser) ||
        community.isModerator(loggedInUser)) {
      canBanOrUnban = true;
    }

    return canBanOrUnban;
  }

  bool isCreatorOfCommunity(Community community) {
    return community.isCreator ?? false;
  }

  bool canChangeDetailsOfCommunity(Community community) {
    User loggedInUser = this;
    bool canChangeDetails = false;

    if (community.isAdministrator(loggedInUser)) {
      canChangeDetails = true;
    }

    return canChangeDetails;
  }

  bool canAddOrRemoveModeratorsInCommunity(Community community) {
    User loggedInUser = this;
    bool canAddOrRemoveMods = false;

    if (community.isAdministrator(loggedInUser)) {
      canAddOrRemoveMods = true;
    }

    return canAddOrRemoveMods;
  }

  bool canAddOrRemoveAdministratorsInCommunity(Community community) {
    return community.isCreator ?? false;
  }

  bool canCommentOnPostWithDisabledComments(Post post) {
    User loggedInUser = this;
    bool canComment = false;

    if (post.hasCommunity()) {
      Community? postCommunity = post.community;

      if (postCommunity == null ||
          postCommunity.isAdministrator(loggedInUser) ||
          postCommunity.isModerator(loggedInUser)) {
        canComment = true;
      }
    }
    return canComment;
  }

  bool isStaffForCommunity(Community? community) {
    User loggedInUser = this;
    bool loggedInUserIsCommunityAdministrator = false;
    bool loggedInUserIsCommunityModerator = false;

    loggedInUserIsCommunityAdministrator =
        community?.isAdministrator(loggedInUser) ?? false;

    loggedInUserIsCommunityModerator =
        community?.isModerator(loggedInUser) ?? false;

    return loggedInUserIsCommunityModerator ||
        loggedInUserIsCommunityAdministrator;
  }

  bool canDeletePost(Post post) {
    User loggedInUser = this;
    bool loggedInUserIsPostCreator = loggedInUser.id == post.getCreatorId();
    bool canDelete = false;
    bool loggedInUserIsStaffForCommunity = false;

    if (post.hasCommunity()) {
      loggedInUserIsStaffForCommunity = isStaffForCommunity(
        post.community,
      );
    }

    if (loggedInUserIsPostCreator || loggedInUserIsStaffForCommunity) {
      canDelete = true;
    }

    return canDelete;
  }

  bool canEditPost(Post post) {
    User loggedInUser = this;
    bool loggedInUserIsPostCreator = loggedInUser.id == post.getCreatorId();

    return loggedInUserIsPostCreator && !(post.isClosed ?? false);
  }

  bool canTranslatePostComment(PostComment postComment, Post post) {
    if ((!post.hasCommunity() && post.isEncircledPost()) ||
        language?.code == null) {
      return false;
    }

    return postComment.hasLanguage() &&
        postComment.getLanguage()?.code != language!.code;
  }

  bool canTranslatePost(Post post) {
    if ((!post.hasCommunity() && post.isEncircledPost()) ||
        language?.code == null) {
      return false;
    }

    return post.hasLanguage() && post.getLanguage()?.code != language!.code;
  }

  bool canEditPostComment(PostComment postComment, Post post) {
    User loggedInUser = this;
    User? postCommenter = postComment.commenter;
    bool loggedInUserIsStaffForCommunity = false;
    bool loggedInUserIsCommenter = loggedInUser.id == postCommenter?.id;
    bool loggedInUserIsCommenterForOpenPost = loggedInUserIsCommenter &&
        !(post.isClosed ?? false) &&
        (post.areCommentsEnabled ?? false);

    if (post.hasCommunity()) {
      loggedInUserIsStaffForCommunity = isStaffForCommunity(post.community);
    }

    return loggedInUserIsCommenterForOpenPost ||
        (loggedInUserIsStaffForCommunity && loggedInUserIsCommenter);
  }

  bool canReportPostComment(PostComment postComment) {
    User loggedInUser = this;
    User? postCommenter = postComment.commenter;

    return loggedInUser.id != postCommenter?.id;
  }

  bool canReplyPostComment(PostComment postComment) {
    return postComment.parentComment == null;
  }

  bool canDeletePostComment(Post post, PostComment postComment) {
    User loggedInUser = this;
    User? postCommenter = postComment.commenter;
    bool loggedInUserIsPostCreator = loggedInUser.id == post.getCreatorId();
    bool userIsCreatorOfNonCommunityPost =
        loggedInUserIsPostCreator && !post.hasCommunity();
    bool loggedInUserIsStaffForCommunity = false;
    bool loggedInUserIsCommenterForOpenPost =
        (loggedInUser.id == postCommenter?.id) && !(post.isClosed ?? false);

    if (post.hasCommunity()) {
      loggedInUserIsStaffForCommunity = isStaffForCommunity(
        post.community,
      );
    }

    return (loggedInUserIsCommenterForOpenPost ||
        loggedInUserIsStaffForCommunity ||
        userIsCreatorOfNonCommunityPost);
  }

  bool canBlockOrUnblockUser(User user) {
    return user.id != id;
  }
}

class UserFactory extends UpdatableModelFactory<User> {
  UserFactory({cache}) : super(cache: cache);

  @override
  User makeFromJson(Map json) {
    return User(
      id: json['id'],
      uuid: json['uuid'],
      dateJoined: parseDateJoined(json['date_joined']),
      // areGuidelinesAccepted: json['are_guidelines_accepted'],
      connectionsCircleId: json['connections_circle_id'],
      followersCount: json['followers_count'],
      postsCount: json['posts_count'],
      inviteCount: json['invite_count'],
      unreadNotificationsCount: json['unread_notifications_count'],
      pendingCommunitiesModeratedObjectsCount:
          json['pending_communities_moderated_objects_count'],
      activeModerationPenaltiesCount: json['active_moderation_penalties_count'],
      email: json['email'],
      username: json['username'],
      visibility: UserVisibility.parse(json['visibility']),
      language: parseLanguage(json['language']),
      followingCount: json['following_count'],
      isFollowing: json['is_following'],
      isFollowed: json['is_followed'],
      isFollowRequested: json['is_follow_requested'],
      areNewPostNotificationsEnabled:
          json['are_new_post_notifications_enabled'],
      isConnected: json['is_connected'],
      isGlobalModerator: json['is_global_moderator'],
      isBlocked: json['is_blocked'],
      isReported: json['is_reported'],
      isFullyConnected: json['is_fully_connected'],
      isMemberOfCommunities: json['is_member_of_communities'],
      isPendingConnectionConfirmation:
          json['is_pending_connection_confirmation'],
      isPendingFollowRequestApproval:
          json['is_pending_follow_request_approval'],
      profile: parseUserProfile(json['profile']),
      connectedCircles: parseCircles(json['connected_circles']),
      communitiesMemberships: parseMemberships(json['communities_memberships']),
      communitiesInvites: parseInvites(json['communities_invites']),
      followLists: parseFollowsLists(json['follow_lists']),
    );
  }

  CommunityMembershipList? parseMemberships(List? membershipsData) {
    if (membershipsData == null) return null;
    return CommunityMembershipList.fromJson(membershipsData);
  }

  CommunityInviteList? parseInvites(List? invitesData) {
    if (invitesData == null) return null;
    return CommunityInviteList.fromJson(invitesData);
  }

  UserProfile? parseUserProfile(Map<String, dynamic>? profile) {
    if (profile == null) return null;
    return UserProfile.fromJSON(profile);
  }

  UserNotificationsSettings? parseUserNotificationsSettings(
    Map<String, dynamic>? notificationsSettings,
  ) {
    if (notificationsSettings == null) return null;
    return UserNotificationsSettings.fromJSON(notificationsSettings);
  }

  CirclesList? parseCircles(List? circlesData) {
    if (circlesData == null) return null;
    return CirclesList.fromJson(circlesData);
  }

  FollowsListsList? parseFollowsLists(List? followsListsData) {
    if (followsListsData == null) return null;
    return FollowsListsList.fromJson(followsListsData);
  }

  Language? parseLanguage(Map<String, dynamic>? languageData) {
    if (languageData == null) return null;
    return Language.fromJson(languageData);
  }

  DateTime? parseDateJoined(String? dateJoined) {
    if (dateJoined == null) return null;
    return DateTime.parse(dateJoined).toLocal();
  }
}

class UserVisibility {
  final String code;

  const UserVisibility._internal(this.code);

  @override
  toString() => code;

  static const public = UserVisibility._internal('P');
  static const kootumb = UserVisibility._internal('O');
  static const private = UserVisibility._internal('T');

  static const _values = <UserVisibility>[public, kootumb, private];

  static List<UserVisibility> values() => _values;

  static UserVisibility? parse(String? string) {
    if (string == null) return null;

    UserVisibility? userVisibility;
    for (var type in _values) {
      if (string == type.code) {
        userVisibility = type;
        break;
      }
    }

    if (userVisibility == null) {
      // Don't throw as we might introduce new notifications on the API which might not be yet in code
      print('Unsupported UserVisibility');
    }

    return userVisibility;
  }
}
