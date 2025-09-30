import 'package:Kootumb/models/post.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/widgets/buttons/button.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBPostActionComment extends StatelessWidget {
  final Post _post;
  final VoidCallback? onWantsToCommentPost;

  const OBPostActionComment(this._post, {Key? key, this.onWantsToCommentPost})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var kongoProvider = KongoProvider.of(context);
    var navigationService = kongoProvider.navigationService;
    var localizationService = kongoProvider.localizationService;

    return OBButton(
        type: OBButtonType.highlight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const OBIcon(
              OBIcons.comment,
              customSize: 20.0,
            ),
            const SizedBox(
              width: 10.0,
            ),
            OBText(localizationService.trans('post__action_comment')),
          ],
        ),
        onPressed: () {
          if (onWantsToCommentPost != null) {
            onWantsToCommentPost!();
          } else {
            navigationService.navigateToCommentPost(
                post: _post, context: context);
          }
        });
  }
}

typedef OnWantsToCommentPost = void Function(Post post);
