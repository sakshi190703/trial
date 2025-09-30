import 'package:Kootumb/models/post.dart';
import 'package:Kootumb/models/post_comment.dart';
import 'package:Kootumb/models/post_comment_list.dart';
import 'package:Kootumb/services/user_preferences.dart';
import 'package:Kootumb/services/user.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBPostCommentsPageController {
  final Post post;
  final PostCommentsPageType pageType;
  PostCommentsSortType currentSort;
  Function(List<PostComment>) setPostComments;
  Function(List<PostComment>) addPostComments;
  Function(List<PostComment>) addToStartPostComments;
  Function(PostCommentsSortType) setCurrentSortValue;
  Function(bool) setNoMoreBottomItemsToLoad;
  Function(bool) setNoMoreTopItemsToLoad;
  VoidCallback showNoMoreTopItemsToLoadToast;
  VoidCallback scrollToTop;
  VoidCallback scrollToNewComment;
  VoidCallback unfocusCommentInput;
  Function(dynamic) onError;
  UserService userService;
  UserPreferencesService userPreferencesService;

  List<PostComment> postComments = [];
  PostComment? linkedPostComment;
  PostComment? postComment;

  static const LOAD_MORE_COMMENTS_COUNT = 5;
  static const COUNT_MIN_INCLUDING_LINKED_COMMENT = 3;
  static const COUNT_MAX_AFTER_LINKED_COMMENT = 2;
  static const TOTAL_COMMENTS_IN_SLICE =
      COUNT_MIN_INCLUDING_LINKED_COMMENT + COUNT_MAX_AFTER_LINKED_COMMENT;

  CancelableOperation? _refreshCommentsOperation;
  CancelableOperation? _refreshCommentsSliceOperation;
  CancelableOperation? _refreshCommentsWithCreatedPostCommentVisibleOperation;
  CancelableOperation? _refreshPostOperation;
  CancelableOperation? _loadMoreBottomCommentsOperation;
  CancelableOperation? _loadMoreTopCommentsOperation;
  CancelableOperation? _toggleSortCommentsOperation;

  OBPostCommentsPageController(
      {required this.post,
      required this.pageType,
      required this.currentSort,
      required this.userService,
      required this.userPreferencesService,
      required this.setPostComments,
      required this.setCurrentSortValue,
      required this.setNoMoreBottomItemsToLoad,
      required this.setNoMoreTopItemsToLoad,
      required this.addPostComments,
      required this.addToStartPostComments,
      required this.showNoMoreTopItemsToLoadToast,
      required this.scrollToTop,
      required this.scrollToNewComment,
      required this.unfocusCommentInput,
      required this.onError,
      this.linkedPostComment,
      this.postComment}) {
    bootstrapController();
  }

  Future bootstrapController() async {
    if (linkedPostComment != null) {
      await refreshCommentsSlice();
    } else {
      await refreshComments();
    }
  }

  CancelableOperation<PostCommentList> retrieveObjects(
      {int? minId,
      int? maxId,
      int? countMax,
      int? countMin,
      PostCommentsSortType? sort}) {
    if (pageType == PostCommentsPageType.comments) {
      return CancelableOperation.fromFuture(userService.getCommentsForPost(post,
          sort: sort,
          minId: minId,
          maxId: maxId,
          countMax: countMax,
          countMin: countMin));
    } else {
      return CancelableOperation.fromFuture(
          userService.getCommentRepliesForPostComment(post, postComment!,
              sort: sort,
              minId: minId,
              maxId: maxId,
              countMax: countMax,
              countMin: countMin));
    }
  }

  void onWantsToToggleSortComments() async {
    PostCommentsSortType newSortType;
    if (currentSort == PostCommentsSortType.asc) {
      newSortType = PostCommentsSortType.dec;
    } else {
      newSortType = PostCommentsSortType.asc;
    }
    userPreferencesService.setPostCommentsSortType(newSortType);
    setNewSortValue(newSortType);
    onWantsToRefreshComments();
  }

  Future onWantsToRefreshComments() async {
    if (_refreshCommentsOperation != null) _refreshCommentsOperation!.cancel();
    try {
      _refreshCommentsOperation = retrieveObjects(sort: currentSort);
      postComments = (await _refreshCommentsOperation!.value).comments;
      setPostComments(postComments);
      setNoMoreBottomItemsToLoad(false);
      setNoMoreTopItemsToLoad(true);
    } catch (error) {
      onError(error);
    } finally {
      _refreshCommentsOperation = null;
    }
  }

  Future<void> refreshComments() async {
    await onWantsToRefreshComments();
    scrollToTop();
  }

  Future<bool> loadMoreTopComments() async {
    if (_loadMoreTopCommentsOperation != null) {
      _loadMoreTopCommentsOperation!.cancel();
    }
    if (postComments.isEmpty) return true;

    List<PostComment> topComments;
    PostComment firstPost = postComments.first;
    int firstPostId = firstPost.id!;
    try {
      if (currentSort == PostCommentsSortType.dec) {
        _loadMoreTopCommentsOperation = retrieveObjects(
            sort: PostCommentsSortType.dec,
            countMin: LOAD_MORE_COMMENTS_COUNT,
            minId: firstPostId + 1);
      } else if (currentSort == PostCommentsSortType.asc) {
        _loadMoreTopCommentsOperation = retrieveObjects(
            sort: PostCommentsSortType.asc,
            countMax: LOAD_MORE_COMMENTS_COUNT,
            maxId: firstPostId);
      }

      topComments = (await _loadMoreTopCommentsOperation!.value).comments;

      if (topComments.length < LOAD_MORE_COMMENTS_COUNT &&
          topComments.isNotEmpty) {
        setNoMoreTopItemsToLoad(true);
        addToStartPostComments(topComments);
      } else if (topComments.length == LOAD_MORE_COMMENTS_COUNT) {
        addToStartPostComments(topComments);
      } else {
        setNoMoreTopItemsToLoad(true);
        showNoMoreTopItemsToLoadToast();
      }
      return true;
    } catch (error) {
      onError(error);
    } finally {
      _loadMoreTopCommentsOperation = null;
    }

    return false;
  }

  Future<bool> loadMoreBottomComments() async {
    if (_loadMoreBottomCommentsOperation != null) {
      _loadMoreBottomCommentsOperation!.cancel();
    }
    if (postComments.isEmpty ||
        _refreshCommentsWithCreatedPostCommentVisibleOperation != null) {
      return true;
    }

    PostComment lastPost = postComments.last;
    int lastPostId = lastPost.id!;
    List<PostComment> moreComments;
    try {
      if (currentSort == PostCommentsSortType.dec) {
        _loadMoreBottomCommentsOperation = retrieveObjects(
            countMax: LOAD_MORE_COMMENTS_COUNT,
            maxId: lastPostId,
            sort: currentSort);
      } else {
        _loadMoreBottomCommentsOperation = retrieveObjects(
            countMin: LOAD_MORE_COMMENTS_COUNT,
            minId: lastPostId + 1,
            sort: currentSort);
      }

      moreComments = (await _loadMoreBottomCommentsOperation!.value).comments;

      if (moreComments.isEmpty) {
        setNoMoreBottomItemsToLoad(true);
      } else {
        addPostComments(moreComments);
      }
      return true;
    } catch (error) {
      onError(error);
    } finally {
      _loadMoreBottomCommentsOperation = null;
    }

    return false;
  }

  Future<void> refreshCommentsSlice() async {
    if (_refreshCommentsSliceOperation != null) {
      _refreshCommentsSliceOperation!.cancel();
    }
    try {
      _refreshCommentsSliceOperation = retrieveObjects(
          minId: linkedPostComment?.id,
          maxId: linkedPostComment?.id,
          countMax: COUNT_MAX_AFTER_LINKED_COMMENT,
          countMin: COUNT_MIN_INCLUDING_LINKED_COMMENT,
          sort: currentSort);

      postComments = (await _refreshCommentsSliceOperation!.value).comments;
      setPostComments(postComments);
      checkIfMoreTopItemsToLoad();
      setNoMoreBottomItemsToLoad(false);
    } catch (error) {
      onError(error);
    } finally {
      _refreshCommentsSliceOperation = null;
    }
  }

  void checkIfMoreTopItemsToLoad() {
    int linkedCommentId = linkedPostComment!.id!;
    Iterable<PostComment> listBeforeLinkedComment = [];
    if (currentSort == PostCommentsSortType.dec) {
      listBeforeLinkedComment =
          postComments.where((comment) => comment.id! > linkedCommentId);
    } else if (currentSort == PostCommentsSortType.asc) {
      listBeforeLinkedComment =
          postComments.where((comment) => comment.id! < linkedCommentId);
    }
    if (listBeforeLinkedComment.length < 2) {
      setNoMoreTopItemsToLoad(true);
    }
  }

  void refreshCommentsWithCreatedPostCommentVisible(
      PostComment createdPostComment) async {
    if (_refreshCommentsWithCreatedPostCommentVisibleOperation != null) {
      _refreshCommentsWithCreatedPostCommentVisibleOperation!.cancel();
    }
    unfocusCommentInput();
    List<PostComment> comments;
    int createdCommentId = createdPostComment.id!;
    try {
      if (currentSort == PostCommentsSortType.dec) {
        _refreshCommentsWithCreatedPostCommentVisibleOperation =
            retrieveObjects(
                sort: PostCommentsSortType.dec,
                countMax: LOAD_MORE_COMMENTS_COUNT,
                maxId: createdCommentId + 1);
        setNoMoreTopItemsToLoad(true);
        setNoMoreBottomItemsToLoad(false);
      } else if (currentSort == PostCommentsSortType.asc) {
        _refreshCommentsWithCreatedPostCommentVisibleOperation =
            retrieveObjects(
                sort: PostCommentsSortType.asc,
                countMax: LOAD_MORE_COMMENTS_COUNT,
                maxId: createdCommentId + 1);
        setNoMoreTopItemsToLoad(false);
        setNoMoreBottomItemsToLoad(false);
      }
      comments =
          (await _refreshCommentsWithCreatedPostCommentVisibleOperation!.value)
              .comments;
      postComments = comments;
      setPostComments(postComments);
      scrollToNewComment();
    } catch (error) {
      onError(error);
    } finally {
      _refreshCommentsWithCreatedPostCommentVisibleOperation = null;
    }
  }

  void setNewSortValue(PostCommentsSortType newSortType) {
    currentSort = newSortType;
    setCurrentSortValue(newSortType);
  }

  void updateControllerPostComments(List<PostComment> comments) {
    postComments = comments;
  }

  void dispose() {
    if (_refreshCommentsOperation != null) _refreshCommentsOperation!.cancel();
    if (_refreshCommentsSliceOperation != null) {
      _refreshCommentsSliceOperation!.cancel();
    }
    if (_loadMoreBottomCommentsOperation != null) {
      _loadMoreBottomCommentsOperation!.cancel();
    }
    if (_refreshPostOperation != null) _refreshPostOperation!.cancel();
    if (_toggleSortCommentsOperation != null) {
      _toggleSortCommentsOperation!.cancel();
    }
    if (_loadMoreTopCommentsOperation != null) {
      _loadMoreTopCommentsOperation!.cancel();
    }
    if (_refreshCommentsWithCreatedPostCommentVisibleOperation != null) {
      _refreshCommentsWithCreatedPostCommentVisibleOperation!.cancel();
    }
  }
}

enum PostCommentsPageType { replies, comments }
