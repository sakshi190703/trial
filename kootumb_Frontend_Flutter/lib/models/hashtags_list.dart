import 'package:Kootumb/models/hashtag.dart';

class HashtagsList {
  final List<Hashtag>? hashtags;

  HashtagsList({
    this.hashtags,
  });

  factory HashtagsList.fromJson(List<dynamic> parsedJson) {
    List<Hashtag> hashtags =
        parsedJson.map((postJson) => Hashtag.fromJSON(postJson)).toList();

    return HashtagsList(
      hashtags: hashtags,
    );
  }
}
