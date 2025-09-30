import 'package:Kootumb/models/post.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/theming/secondary_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBPostComments extends StatelessWidget {
  final Post _post;

  const OBPostComments(this._post, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _post.updateSubject,
      initialData: _post,
      builder: (BuildContext context, AsyncSnapshot<Post> snapshot) {
        int? commentsCount = _post.commentsCount;
        var kongoProvider = KongoProvider.of(context);
        var navigationService = kongoProvider.navigationService;
        LocalizationService localizationService =
            kongoProvider.localizationService;

        bool isClosed = _post.isClosed ?? false;
        bool hasComments = commentsCount! > 0;
        bool areCommentsEnabled = _post.areCommentsEnabled ?? true;
        bool canDisableOrEnableCommentsForPost = false;

        if (!areCommentsEnabled) {
          canDisableOrEnableCommentsForPost = kongoProvider.userService
                  .getLoggedInUser()
                  ?.canDisableOrEnableCommentsForPost(_post) ??
              false;
        }

        List<Widget> rowItems = [];

        if (hasComments) {
          rowItems.add(
            GestureDetector(
              onTap: () {
                navigationService.navigateToPostComments(
                  post: _post,
                  context: context,
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: OBSecondaryText(
                  localizationService.post__comments_view_all_comments(
                    commentsCount,
                  ),
                ),
              ),
            ),
          );
        }

        if (isClosed ||
            (!areCommentsEnabled && canDisableOrEnableCommentsForPost)) {
          List<Widget> secondaryItems = [];

          if (isClosed) {
            secondaryItems.add(
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  const OBIcon(OBIcons.closePost, size: OBIconSize.small),
                  const SizedBox(width: 10),
                  OBSecondaryText(
                    localizationService.post__comments_closed_post,
                  ),
                ],
              ),
            );
          }

          if (!areCommentsEnabled && canDisableOrEnableCommentsForPost) {
            secondaryItems.add(
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  const OBIcon(OBIcons.disableComments, size: OBIconSize.small),
                  const SizedBox(width: 10),
                  OBSecondaryText(localizationService.post__comments_disabled),
                ],
              ),
            );
          }

          rowItems.addAll([
            const SizedBox(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: secondaryItems,
              ),
            ),
          ]);
        }

        return Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [Row(children: rowItems)],
          ),
        );
      },
    );
  }
}

typedef OnWantsToSeePostComments = void Function(Post post);
