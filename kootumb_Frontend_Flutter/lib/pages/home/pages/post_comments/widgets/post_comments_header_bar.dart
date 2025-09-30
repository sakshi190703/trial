import 'package:Kootumb/models/post_comment.dart';
import 'package:Kootumb/pages/home/pages/post_comments/post_comments_page_controller.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/services/theme.dart';
import 'package:Kootumb/services/theme_value_parser.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/material.dart';
import 'package:Kootumb/widgets/theming/secondary_text.dart';

class OBPostCommentsHeaderBar extends StatelessWidget {
  PostCommentsPageType pageType;
  bool noMoreTopItemsToLoad;
  List<PostComment> postComments;
  PostCommentsSortType currentSort;
  VoidCallback onWantsToToggleSortComments;
  VoidCallback loadMoreTopComments;
  VoidCallback onWantsToRefreshComments;

  OBPostCommentsHeaderBar({
    Key? key,
    required this.pageType,
    required this.noMoreTopItemsToLoad,
    required this.postComments,
    required this.currentSort,
    required this.onWantsToToggleSortComments,
    required this.loadMoreTopComments,
    required this.onWantsToRefreshComments,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = KongoProvider.of(context);
    ThemeService themeService = provider.themeService;
    LocalizationService localizationService = provider.localizationService;
    ThemeValueParserService themeValueParserService =
        provider.themeValueParserService;
    var theme = themeService.getActiveTheme();
    late Map<String, String> pageTextMap;
    if (pageType == PostCommentsPageType.comments) {
      pageTextMap = getPageCommentsMap(localizationService);
    } else {
      pageTextMap = getPageRepliesMap(localizationService);
    }

    if (noMoreTopItemsToLoad) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                child: OBSecondaryText(
                  postComments.isNotEmpty
                      ? currentSort == PostCommentsSortType.dec
                          ? pageTextMap['NEWEST']!
                          : pageTextMap['OLDEST']!
                      : pageTextMap['BE_THE_FIRST']!,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
              ),
            ),
            Expanded(
              child: MaterialButton(
                  onPressed: onWantsToToggleSortComments,
                  child: OBText(
                    this.postComments.isNotEmpty
                        ? currentSort == PostCommentsSortType.dec
                            ? pageTextMap['SEE_OLDEST']!
                            : pageTextMap['SEE_NEWEST']!
                        : '',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: themeValueParserService
                            .parseGradient(theme.primaryAccentColor)
                            .colors[1],
                        fontWeight: FontWeight.bold),
                  )),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 4,
              child: MaterialButton(
                  onPressed: loadMoreTopComments,
                  child: Row(
                    children: <Widget>[
                      OBIcon(OBIcons.arrowUp),
                      const SizedBox(width: 10.0),
                      OBText(
                        currentSort == PostCommentsSortType.dec
                            ? pageTextMap['NEWER']!
                            : pageTextMap['OLDER']!,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
            ),
            Expanded(
              flex: 6,
              child: MaterialButton(
                  onPressed: onWantsToRefreshComments,
                  child: OBText(
                    currentSort == PostCommentsSortType.dec
                        ? pageTextMap['VIEW_NEWEST']!
                        : pageTextMap['VIEW_OLDEST']!,
                    style: TextStyle(
                        color: themeValueParserService
                            .parseGradient(theme.primaryAccentColor)
                            .colors[1],
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  )),
            ),
          ],
        ),
      );
    }
  }

  Map<String, String> getPageCommentsMap(
      LocalizationService localizationService) {
    return {
      'NEWEST': localizationService.post__comments_header_newest_comments,
      'NEWER': localizationService.post__comments_header_newer,
      'VIEW_NEWEST':
          localizationService.post__comments_header_view_newest_comments,
      'SEE_NEWEST':
          localizationService.post__comments_header_see_newest_comments,
      'OLDEST': localizationService.post__comments_header_oldest_comments,
      'OLDER': localizationService.post__comments_header_older,
      'VIEW_OLDEST':
          localizationService.post__comments_header_view_oldest_comments,
      'SEE_OLDEST':
          localizationService.post__comments_header_see_oldest_comments,
      'BE_THE_FIRST':
          localizationService.post__comments_header_be_the_first_comments,
    };
  }

  Map<String, String> getPageRepliesMap(
      LocalizationService localizationService) {
    return {
      'NEWEST': localizationService.post__comments_header_newest_replies,
      'NEWER': localizationService.post__comments_header_newer,
      'VIEW_NEWEST':
          localizationService.post__comments_header_view_newest_replies,
      'SEE_NEWEST':
          localizationService.post__comments_header_see_newest_replies,
      'OLDEST': localizationService.post__comments_header_oldest_replies,
      'OLDER': localizationService.post__comments_header_older,
      'VIEW_OLDEST':
          localizationService.post__comments_header_view_oldest_replies,
      'SEE_OLDEST':
          localizationService.post__comments_header_see_oldest_replies,
      'BE_THE_FIRST':
          localizationService.post__comments_header_be_the_first_replies,
    };
  }
}
