import 'package:Kootumb/models/post.dart';
import 'package:Kootumb/widgets/post/widgets/post-actions/post_actions.dart';
import 'package:Kootumb/widgets/post/widgets/post-body/post_body.dart';
import 'package:Kootumb/widgets/post/widgets/post_circles.dart';
import 'package:Kootumb/widgets/post/widgets/post_comments/post_comments.dart';
import 'package:Kootumb/widgets/post/widgets/post_header/post_header.dart';
import 'package:Kootumb/widgets/post/widgets/post_reactions.dart';
import 'package:Kootumb/widgets/theming/post_divider.dart';
import 'package:flutter/material.dart';

class OBPostPreview extends StatelessWidget {
  final Post post;
  final Function(Post)? onPostDeleted;
  final VoidCallback? focusCommentInput;
  final bool showViewAllCommentsAction;

  const OBPostPreview(
      {Key? key,
      required this.post,
      this.onPostDeleted,
      this.focusCommentInput,
      this.showViewAllCommentsAction = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        OBPostHeader(
          post: post,
          onPostDeleted: onPostDeleted,
        ),
        OBPostBody(post),
        const SizedBox(
          height: 20,
        ),
        OBPostReactions(post),
        const SizedBox(
          height: 10,
        ),
        OBPostCircles(post),
        showViewAllCommentsAction == true
            ? OBPostComments(
                post,
              )
            : SizedBox(),
        OBPostActions(
          post,
          onWantsToCommentPost: focusCommentInput,
        ),
        const SizedBox(
          height: 16,
        ),
        OBPostDivider()
      ],
    );
  }
}
