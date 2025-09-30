import 'package:Kootumb/models/emoji.dart';
import 'package:Kootumb/models/post.dart';
import 'package:Kootumb/models/post_comment.dart';
import 'package:Kootumb/models/reactions_emoji_count.dart';
import 'package:Kootumb/models/theme.dart';
import 'package:Kootumb/pages/home/modals/post_comment_reactions/widgets/post_comment_reaction_list.dart';
import 'package:Kootumb/services/theme.dart';
import 'package:Kootumb/services/theme_value_parser.dart';
import 'package:Kootumb/widgets/emoji_picker/widgets/emoji_groups/widgets/emoji_group/widgets/emoji.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/widgets/page_scaffold.dart';
import 'package:Kootumb/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBPostCommentReactionsModal extends StatefulWidget {
  // The post and comment to display the reactions for
  final PostComment postComment;
  final Post post;

  // The optional emoji to show first
  final Emoji? reactionEmoji;

  // The post comment reaction emoji counts
  final List<ReactionsEmojiCount?> reactionsEmojiCounts;

  const OBPostCommentReactionsModal(
      {Key? key,
      required this.postComment,
      this.reactionEmoji,
      required this.reactionsEmojiCounts,
      required this.post})
      : super(key: key);

  @override
  OBPostCommentReactionsModalState createState() {
    return OBPostCommentReactionsModalState();
  }
}

class OBPostCommentReactionsModalState
    extends State<OBPostCommentReactionsModal> with TickerProviderStateMixin {
  late ThemeService _themeService;
  late ThemeValueParserService _themeValueParserService;
  late bool _needsBootstrap;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _tabController =
        TabController(length: widget.reactionsEmojiCounts.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var kongoProvider = KongoProvider.of(context);
      _themeService = kongoProvider.themeService;
      _themeValueParserService = kongoProvider.themeValueParserService;
      _bootstrap();
      _needsBootstrap = false;
    }

    OBTheme theme = _themeService.getActiveTheme();

    Color tabIndicatorColor = _themeValueParserService
        .parseGradient(theme.primaryAccentColor)
        .colors[1];

    return OBCupertinoPageScaffold(
        navigationBar: _buildNavigationBar(),
        child: OBPrimaryColorContainer(
          child: Column(
            children: <Widget>[
              TabBar(
                controller: _tabController,
                tabs: _buildPostCommentReactionsIcons(),
                isScrollable: true,
                indicatorColor: tabIndicatorColor,
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: _buildPostCommentReactionsTabs(),
                ),
              )
            ],
          ),
        ));
  }

  List<Widget> _buildPostCommentReactionsTabs() {
    return widget.reactionsEmojiCounts.map((reactionsEmojiCount) {
      if (reactionsEmojiCount == null) {
        return SizedBox();
      }

      return OBPostCommentReactionList(
        postComment: widget.postComment,
        post: widget.post,
        emoji: reactionsEmojiCount.emoji!,
      );
    }).toList();
  }

  List<Widget> _buildPostCommentReactionsIcons() {
    return widget.reactionsEmojiCounts.map((reactionsEmojiCount) {
      if (reactionsEmojiCount == null) {
        return SizedBox();
      }

      return Padding(
        padding: EdgeInsets.symmetric(vertical: 5),
        child: Tab(icon: OBEmoji(reactionsEmojiCount.emoji!)),
      );
    }).toList();
  }

  ObstructingPreferredSizeWidget _buildNavigationBar() {
    return OBThemedNavigationBar(
        title: 'Post comment reactions',
        leading: OBIcon(
          OBIcons.close,
          size: OBIconSize.notVisi,
        ));
  }

  void _bootstrap() async {
    int tabIndex = 0;

    if (widget.reactionEmoji != null) {
      tabIndex = widget.reactionsEmojiCounts.indexWhere((reactionEmojiCount) {
        return reactionEmojiCount?.emoji?.id == widget.reactionEmoji!.id;
      });
    }

    _tabController.index = tabIndex;
  }
}
