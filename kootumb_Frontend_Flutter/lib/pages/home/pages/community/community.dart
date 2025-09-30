import 'package:Kootumb/models/community.dart';
import 'package:Kootumb/models/post.dart';
import 'package:Kootumb/models/posts_list.dart';
import 'package:Kootumb/models/theme.dart';
import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/pages/home/pages/community/pages/community_staff/widgets/community_administrators.dart';
import 'package:Kootumb/pages/home/pages/community/pages/community_staff/widgets/community_moderators.dart';
import 'package:Kootumb/pages/home/pages/community/widgets/community_card/community_card.dart';
import 'package:Kootumb/pages/home/pages/community/widgets/community_cover.dart';
import 'package:Kootumb/pages/home/pages/community/widgets/community_nav_bar.dart';
import 'package:Kootumb/pages/home/pages/community/widgets/community_posts_stream_status_indicator.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/services/user.dart';
import 'package:Kootumb/widgets/alerts/alert.dart';
import 'package:Kootumb/widgets/buttons/community_new_post_button.dart';
import 'package:Kootumb/widgets/new_post_data_uploader.dart';
import 'package:Kootumb/widgets/post/post.dart';
import 'package:Kootumb/widgets/posts_stream/posts_stream.dart';
import 'package:Kootumb/widgets/theming/primary_color_container.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class OBCommunityPage extends StatefulWidget {
  final Community community;

  const OBCommunityPage(this.community, {Key? key}) : super(key: key);

  @override
  OBCommunityPageState createState() {
    return OBCommunityPageState();
  }
}

class OBCommunityPageState extends State<OBCommunityPage>
    with TickerProviderStateMixin {
  late Community _community;
  late OBPostsStreamController _obPostsStreamController;
  late ScrollController _obPostsStreamScrollController;
  late UserService _userService;
  late LocalizationService _localizationService;

  late bool _needsBootstrap;

  CancelableOperation? _refreshCommunityOperation;

  late List<OBNewPostData> _newPostsData;

  final double _hideFloatingButtonTolerance = 10;
  late AnimationController _hideFloatingButtonAnimation;
  late double _previousScrollPixels;

  @override
  void initState() {
    super.initState();
    _obPostsStreamScrollController = ScrollController();
    _obPostsStreamController = OBPostsStreamController();
    _needsBootstrap = true;
    _community = widget.community;
    _newPostsData = [];

    _hideFloatingButtonAnimation =
        AnimationController(vsync: this, duration: kThemeAnimationDuration);
    _previousScrollPixels = 0;
    _hideFloatingButtonAnimation.forward();

    _obPostsStreamScrollController.addListener(() {
      double newScrollPixelPosition =
          _obPostsStreamScrollController.position.pixels;
      double scrollPixelDifference =
          _previousScrollPixels - newScrollPixelPosition;

      if (_obPostsStreamScrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (scrollPixelDifference * -1 > _hideFloatingButtonTolerance) {
          _hideFloatingButtonAnimation.reverse();
        }
      } else {
        if (scrollPixelDifference > _hideFloatingButtonTolerance) {
          _hideFloatingButtonAnimation.forward();
        }
      }

      _previousScrollPixels = newScrollPixelPosition;
    });
  }

  void _onWantsToUploadNewPostData(OBNewPostData newPostData) {
    _insertNewPostData(newPostData);
  }

  @override
  void dispose() {
    _hideFloatingButtonAnimation.dispose();
    super.dispose();
    if (_refreshCommunityOperation != null) {
      _refreshCommunityOperation!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      KongoProviderState kongoProvider = KongoProvider.of(context);
      _userService = kongoProvider.userService;
      _localizationService = kongoProvider.localizationService;
      _needsBootstrap = false;

      // If the user doesn't have permission to view the community we need to
      // manually trigger a refresh here to make sure the model contains all
      // relevant community information (like admins and moderators).
      //
      // If the user can see the content, a refresh will be triggered
      // automatically by the OBPostsStream.
      if (!_userCanSeeCommunityContent(_community)) {
        _refreshCommunity();
      }
    }

    return CupertinoPageScaffold(
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        navigationBar: OBCommunityNavBar(
          _community,
        ),
        child: OBPrimaryColorContainer(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: StreamBuilder(
                    stream: _community.updateSubject,
                    initialData: _community,
                    builder: (BuildContext context,
                        AsyncSnapshot<Community> snapshot) {
                      Community latestCommunity = snapshot.data!;

                      return _userCanSeeCommunityContent(latestCommunity)
                          ? _buildCommunityContent()
                          : _buildPrivateCommunityContent();
                    }),
              )
            ],
          ),
        ));
  }

  bool _userCanSeeCommunityContent(Community community) {
    bool communityIsPrivate = community.isPrivate();

    User loggedInUser = _userService.getLoggedInUser()!;
    bool userIsMember = community.isMember(loggedInUser);

    return !communityIsPrivate || userIsMember;
  }

  Widget _buildCommunityContent() {
    List<Widget> prependedItems = [
      OBCommunityCover(_community),
      OBCommunityCard(
        _community,
      )
    ];

    if (_newPostsData.isNotEmpty) {
      prependedItems.addAll(_newPostsData.map((OBNewPostData newPostData) {
        return _buildNewPostDataUploader(newPostData);
      }).toList());
    }

    List<Widget> stackItems = [
      OBPostsStream(
        scrollController: _obPostsStreamScrollController,
        onScrollLoader: _loadMoreCommunityPosts,
        refresher: _refreshCommunityPosts,
        controller: _obPostsStreamController,
        prependedItems: prependedItems,
        displayContext: OBPostDisplayContext.communityPosts,
        streamIdentifier: 'community_${widget.community.name!}',
        secondaryRefresher: _refreshCommunity,
        statusIndicatorBuilder: _buildPostsStreamStatusIndicator,
      ),
    ];

    KongoProviderState kongoProvider = KongoProvider.of(context);
    User loggedInUser = kongoProvider.userService.getLoggedInUser()!;
    bool isMemberOfCommunity = _community.isMember(loggedInUser);

    if (isMemberOfCommunity) {
      stackItems.add(Positioned(
          bottom: 20.0,
          right: 20.0,
          child: ScaleTransition(
            scale: _hideFloatingButtonAnimation,
            child: OBCommunityNewPostButton(
              community: _community,
              onWantsToUploadNewPostData: _onWantsToUploadNewPostData,
            ),
          )));
    }

    return Stack(
      children: stackItems,
    );
  }

  Widget _buildPostsStreamStatusIndicator(
      {required BuildContext context,
      required OBPostsStreamStatus streamStatus,
      required List<Widget> streamPrependedItems,
      required Function streamRefresher}) {
    return OBCommunityPostsStreamStatusIndicator(
        streamRefresher: streamRefresher as VoidCallback,
        streamPrependedItems: streamPrependedItems,
        streamStatus: streamStatus);
  }

  Widget _buildNewPostDataUploader(OBNewPostData newPostData) {
    return OBNewPostDataUploader(
      data: newPostData,
      onPostPublished: _onNewPostDataUploaderPostPublished,
      onCancelled: _onNewPostDataUploaderCancelled,
    );
  }

  void _onNewPostDataUploaderCancelled(OBNewPostData newPostData) {
    _removeNewPostData(newPostData);
  }

  void _onNewPostDataUploaderPostPublished(
      Post publishedPost, OBNewPostData newPostData) {
    _removeNewPostData(newPostData);
    _community.incrementPostsCount();
    _obPostsStreamController.addPostToTop(publishedPost);
  }

  Widget _buildPrivateCommunityContent() {
    bool communityHasInvitesEnabled = _community.invitesEnabled ?? false;
    return ListView(
      padding: EdgeInsets.all(0),
      children: <Widget>[
        OBCommunityCover(_community),
        OBCommunityCard(
          _community,
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: OBAlert(
            child: Column(
              children: <Widget>[
                OBText(_localizationService.trans('community__is_private'),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    textAlign: TextAlign.center),
                const SizedBox(
                  height: 10,
                ),
                OBText(
                  communityHasInvitesEnabled
                      ? _localizationService
                          .trans('community__invited_by_member')
                      : _localizationService
                          .trans('community__invited_by_moderator'),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
        OBCommunityAdministrators(_community),
        OBCommunityModerators(_community)
      ],
    );
  }

  Future<void> _refreshCommunity() async {
    if (_refreshCommunityOperation != null) {
      _refreshCommunityOperation!.cancel();
    }
    _refreshCommunityOperation = CancelableOperation.fromFuture(
        _userService.getCommunityWithName(_community.name!));
    debugPrint(_localizationService.trans('community__refreshing'));
    var community = await _refreshCommunityOperation?.value;
    _setCommunity(community);
  }

  Future<List<Post>> _refreshCommunityPosts() async {
    debugPrint('Refreshing community posts');
    PostsList communityPosts =
        await _userService.getPostsForCommunity(widget.community);
    return communityPosts.posts ?? [];
  }

  Future<List<Post>> _loadMoreCommunityPosts(
      List<Post> communityPostsList) async {
    debugPrint('Loading more community posts');
    var lastCommunityPost = communityPostsList.last;
    var lastCommunityPostId = lastCommunityPost.id;
    var moreCommunityPosts = (await _userService.getPostsForCommunity(
      widget.community,
      maxId: lastCommunityPostId,
      count: 10,
    ))
        .posts;
    return moreCommunityPosts ?? [];
  }

  void _setCommunity(Community community) {
    setState(() {
      _community = community;
    });
  }

  void _insertNewPostData(OBNewPostData newPostData) {
    setState(() {
      _newPostsData.insert(0, newPostData);
    });
  }

  void _removeNewPostData(OBNewPostData newPostData) {
    setState(() {
      _newPostsData.remove(newPostData);
    });
  }
}

class CommunityTabBarDelegate extends SliverPersistentHeaderDelegate {
  CommunityTabBarDelegate({
    this.controller,
    this.pageStorageKey,
    this.community,
  });

  final TabController? controller;
  final Community? community;
  final PageStorageKey? pageStorageKey;

  @override
  double get minExtent => kToolbarHeight;

  @override
  double get maxExtent => kToolbarHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    var kongoProvider = KongoProvider.of(context);
    var themeService = kongoProvider.themeService;
    var localizationService = kongoProvider.localizationService;
    var themeValueParserService = kongoProvider.themeValueParserService;

    return StreamBuilder(
        stream: themeService.themeChange,
        initialData: themeService.getActiveTheme(),
        builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
          var theme = snapshot.data;

          Color themePrimaryTextColor =
              themeValueParserService.parseColor(theme!.primaryTextColor);

          return SizedBox(
            height: kToolbarHeight,
            child: TabBar(
              controller: controller,
              key: pageStorageKey,
              indicatorColor: themePrimaryTextColor,
              labelColor: themePrimaryTextColor,
              tabs: <Widget>[
                Tab(text: localizationService.trans('community__posts')),
                Tab(text: localizationService.trans('community__about')),
              ],
            ),
          );
        });
  }

  @override
  bool shouldRebuild(covariant CommunityTabBarDelegate oldDelegate) {
    return oldDelegate.controller != controller;
  }
}

typedef OnWantsToEditUserCommunity = void Function(User user);
