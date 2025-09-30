import 'package:Kootumb/models/post_comment_reaction.dart';

class PostCommentReactionList {
  final List<PostCommentReaction>? reactions;

  PostCommentReactionList({
    this.reactions,
  });

  factory PostCommentReactionList.fromJson(List<dynamic> parsedJson) {
    List<PostCommentReaction> postCommentReactions = parsedJson
        .map((postCommentJson) => PostCommentReaction.fromJson(postCommentJson))
        .toList();

    return PostCommentReactionList(
      reactions: postCommentReactions,
    );
  }
}
