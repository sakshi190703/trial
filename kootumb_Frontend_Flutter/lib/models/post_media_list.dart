import 'package:Kootumb/models/post_media.dart';

class PostMediaList {
  final List<PostMedia>? postMedia;

  PostMediaList({
    this.postMedia,
  });

  factory PostMediaList.fromJson(List<dynamic> parsedJson) {
    List<PostMedia> postMedia =
        parsedJson.map((postJson) => PostMedia.fromJSON(postJson)).toList();

    return PostMediaList(
      postMedia: postMedia,
    );
  }
}
