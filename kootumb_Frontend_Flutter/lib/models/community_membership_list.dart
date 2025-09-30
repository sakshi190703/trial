import 'package:Kootumb/models/community_membership.dart';

class CommunityMembershipList {
  final List<CommunityMembership>? communityMemberships;

  CommunityMembershipList({
    this.communityMemberships,
  });

  factory CommunityMembershipList.fromJson(List<dynamic> parsedJson) {
    List<CommunityMembership> communityMemberships = parsedJson
        .map((communityMembershipJson) =>
            CommunityMembership.fromJSON(communityMembershipJson))
        .toList();

    return CommunityMembershipList(
      communityMemberships: communityMemberships,
    );
  }
}
