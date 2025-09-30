import 'dart:async';
import 'dart:io';

import 'package:Kootumb/models/circle.dart';
import 'package:Kootumb/models/follows_list.dart';
import 'package:Kootumb/models/post.dart';
import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/pages/home/lib/poppable_page_controller.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/services/modal_service.dart';
import 'package:Kootumb/services/theme.dart';
import 'package:Kootumb/services/theme_value_parser.dart';
import 'package:Kootumb/services/user.dart';
import 'package:Kootumb/widgets/badges/badge.dart';
import 'package:Kootumb/widgets/buttons/button.dart';
import 'package:Kootumb/widgets/buttons/floating_action_button.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/icon_button.dart';
import 'package:Kootumb/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Kootumb/widgets/page_scaffold.dart';
import 'package:Kootumb/widgets/new_post_data_uploader.dart';
import 'package:Kootumb/widgets/posts_stream/posts_stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class OBTimelinePage extends StatefulWidget {
  final OBTimelinePageController controller;

  const OBTimelinePage({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  OBTimelinePageState createState() {
    return OBTimelinePageState();
  }
}

class OBTimelinePageState extends State<OBTimelinePage>
    with TickerProviderStateMixin {
  late OBPostsStreamController _timelinePostsStreamController;
  late ScrollController _timelinePostsStreamScrollController;
  late ModalService _modalService;
  late UserService _userService;
  late LocalizationService _localizationService;
  late ThemeService _themeService;
  late ThemeValueParserService _themeValueParserService;

  List<Post>? _initialPosts;
  late List<OBNewPostData> _newPostsData;
  late List<Circle> _filteredCircles;
  late List<FollowsList> _filteredFollowsLists;

  late StreamSubscription _loggedInUserChangeSubscription;

  late bool _needsBootstrap;
  late bool _loggedInUserBootstrapped;

  final double _hideFloatingButtonTolerance = 10;
  late AnimationController _hideFloatingButtonAnimation;
  late double _previousScrollPixels;

  @override
  void initState() {
    super.initState();
    _timelinePostsStreamController = OBPostsStreamController();
    _timelinePostsStreamScrollController = ScrollController();
    widget.controller.attach(context: context, state: this);
    _needsBootstrap = true;
    _loggedInUserBootstrapped = false;
    _filteredCircles = [];
    _filteredFollowsLists = [];
    _newPostsData = [];
    _hideFloatingButtonAnimation =
        AnimationController(vsync: this, duration: kThemeAnimationDuration);
    _hideFloatingButtonAnimation.forward();

    _previousScrollPixels = 0;

    _timelinePostsStreamScrollController.addListener(() {
      double newScrollPixelPosition =
          _timelinePostsStreamScrollController.position.pixels;
      double scrollPixelDifference =
          _previousScrollPixels - newScrollPixelPosition;

      if (_timelinePostsStreamScrollController.position.userScrollDirection ==
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

  @override
  void dispose() {
    _hideFloatingButtonAnimation.dispose();
    super.dispose();
    _loggedInUserChangeSubscription.cancel();
  }

  void _bootstrap() async {
    _loggedInUserChangeSubscription =
        _userService.loggedInUserChange.listen(_onLoggedInUserChange);
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var kongoProvider = KongoProvider.of(context);
      _modalService = kongoProvider.modalService;
      _localizationService = kongoProvider.localizationService;
      _userService = kongoProvider.userService;
      _themeService = kongoProvider.themeService;
      _themeService = kongoProvider.themeService;
      _themeValueParserService = kongoProvider.themeValueParserService;
      _bootstrap();
      _needsBootstrap = false;
    }

    return OBCupertinoPageScaffold(
        backgroundColor: _themeValueParserService
            .parseColor(_themeService.getActiveTheme().primaryColor),
        navigationBar: OBThemedNavigationBar(
            title: 'Home', trailing: _buildFiltersButton()),
        child: Stack(
          children: <Widget>[
            _loggedInUserBootstrapped
                ? OBPostsStream(
                    controller: _timelinePostsStreamController,
                    scrollController: _timelinePostsStreamScrollController,
                    prependedItems: _buildPostsStreamPrependedItems(),
                    streamIdentifier: 'timeline',
                    onScrollLoader: _postsStreamOnScrollLoader,
                    refresher: _postsStreamRefresher,
                    initialPosts: _initialPosts,
                  )
                : const SizedBox(),
            Positioned(
                bottom: 20.0,
                right: 20.0,
                child: Semantics(
                    button: true,
                    label: _localizationService.post__create_new_post_label,
                    child: ScaleTransition(
                        scale: _hideFloatingButtonAnimation,
                        child: OBFloatingActionButton(
                            type: OBButtonType.primary,
                            onPressed: _onCreatePost,
                            child: const OBIcon(OBIcons.createPost,
                                size: OBIconSize.large, color: Colors.white)))))
          ],
        ));
  }

  List<Widget> _buildPostsStreamPrependedItems() {
    return _buildNewPostDataUploaders();
  }

  List<Widget> _buildNewPostDataUploaders() {
    return _newPostsData.map(_buildNewPostDataUploader).toList();
  }

  Widget _buildNewPostDataUploader(OBNewPostData newPostData) {
    return OBNewPostDataUploader(
      key: Key(newPostData.getUniqueKey()),
      data: newPostData,
      onPostPublished: _onNewPostDataUploaderPostPublished,
      onCancelled: _onNewPostDataUploaderCancelled,
    );
  }

  Widget _buildFiltersButton() {
    int filtersCount = countFilters();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        OBBadge(
          count: filtersCount,
        ),
        const SizedBox(
          width: 10,
        ),
        OBIconButton(
          OBIcons.filter,
          themeColor: OBIconThemeColor.primaryAccent,
          onPressed: _onWantsFilters,
        )
      ],
    );
  }

  void _onLoggedInUserChange(User? newUser) async {
    if (newUser == null) return;
    List<Post>? initialPosts = (await _userService.getStoredFirstPosts()).posts;
    setState(() {
      _loggedInUserBootstrapped = true;
      _initialPosts = initialPosts;
      _loggedInUserChangeSubscription.cancel();
    });
  }

  Future<List<Post>> _postsStreamRefresher() async {
    bool cachePosts = _filteredCircles.isEmpty && _filteredFollowsLists.isEmpty;

    List<Post>? posts = (await _userService.getTimelinePosts(
            count: 10,
            circles: _filteredCircles,
            followsLists: _filteredFollowsLists,
            cachePosts: cachePosts))
        .posts;

    return posts ?? [];
  }

  Future<List<Post>> _postsStreamOnScrollLoader(List<Post> posts) async {
    Post lastPost = posts.last;
    int lastPostId = lastPost.id!;

    List<Post>? morePosts = (await _userService.getTimelinePosts(
            maxId: lastPostId,
            circles: _filteredCircles,
            count: 10,
            followsLists: _filteredFollowsLists))
        .posts;

    return morePosts ?? [];
  }

  Future<bool> _onCreatePost({String? text, File? image, File? video}) async {
    OBNewPostData? createPostData = await _modalService.openCreatePost(
        text: text, image: image, video: video, context: context);
    if (createPostData != null) {
      addNewPostData(createPostData);
      _timelinePostsStreamController.scrollToTop(skipRefresh: true);

      return true;
    }

    return false;
  }

  Future<void> setFilters(
      {List<Circle>? circles, List<FollowsList>? followsLists}) async {
    if (circles != null) {
      _filteredCircles = circles;
    }

    if (followsLists != null) {
      _filteredFollowsLists = followsLists;
    }

    return _timelinePostsStreamController.refreshPosts();
  }

  Future<void>? clearFilters() {
    _filteredCircles = [];
    _filteredFollowsLists = [];
    return _timelinePostsStreamController.refreshPosts();
  }

  List<Circle> getFilteredCircles() {
    return _filteredCircles.toList();
  }

  List<FollowsList> getFilteredFollowsLists() {
    return _filteredFollowsLists.toList();
  }

  int countFilters() {
    return _filteredCircles.length + _filteredFollowsLists.length;
  }

  void _onNewPostDataUploaderCancelled(OBNewPostData newPostData) {
    _removeNewPostData(newPostData);
  }

  void _onNewPostDataUploaderPostPublished(
      Post publishedPost, OBNewPostData newPostData) {
    _timelinePostsStreamController.addPostToTop(publishedPost);
    _removeNewPostData(newPostData);
  }

  void addNewPostData(OBNewPostData postUploaderData) {
    setState(() {
      _newPostsData.insert(0, postUploaderData);
    });
  }

  void _removeNewPostData(OBNewPostData postUploaderData) {
    setState(() {
      _newPostsData.remove(postUploaderData);
    });
  }

  void scrollToTop() {
    _timelinePostsStreamController.scrollToTop();
  }

  void _onWantsFilters() {
    _modalService.openTimelineFilters(
        timelineController: widget.controller, context: context);
  }
}

class OBTimelinePageController extends PoppablePageController {
  OBTimelinePageState? _state;

  @override
  void attach({required BuildContext context, OBTimelinePageState? state}) {
    super.attach(context: context);
    _state = state;
  }

  Future<void> setPostFilters(
      {List<Circle>? circles, List<FollowsList>? followsLists}) async {
    return _state?.setFilters(circles: circles, followsLists: followsLists);
  }

  Future<void> clearPostFilters(
      {List<Circle>? circles, List<FollowsList>? followsLists}) async {
    return _state?.setFilters(circles: circles, followsLists: followsLists);
  }

  List<Circle> getFilteredCircles() {
    return _state?.getFilteredCircles() ?? [];
  }

  List<FollowsList> getFilteredFollowsLists() {
    return _state?.getFilteredFollowsLists() ?? [];
  }

  Future<bool> createPost({String? text, File? image, File? video}) {
    if (_state == null) {
      return Future.value(false);
    }

    return _state!._onCreatePost(text: text, image: image, video: video);
  }

  void scrollToTop() {
    _state?.scrollToTop();
  }
}
