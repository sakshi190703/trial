import 'package:Kootumb/models/community.dart';

class CommunitiesList {
  final List<Community>? communities;

  CommunitiesList({
    this.communities,
  });

  factory CommunitiesList.fromJson(List<dynamic> parsedJson) {
    List<Community> communities = parsedJson
        .map((communityJson) => Community.fromJSON(communityJson))
        .toList();

    return CommunitiesList(
      communities: communities,
    );
  }
}
