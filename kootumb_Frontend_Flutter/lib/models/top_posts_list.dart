import 'package:Kootumb/models/top_post.dart';

class TopPostsList {
  final List<TopPost>? posts;

  TopPostsList({
    this.posts,
  });

  factory TopPostsList.fromJson(List<dynamic> parsedJson) {
    List<TopPost> posts =
        parsedJson.map((postJson) => TopPost.fromJson(postJson)).toList();

    return TopPostsList(
      posts: posts,
    );
  }
}
