import 'dart:async';
import 'dart:io';

import 'package:Kootumb/models/circle.dart';
import 'package:Kootumb/models/community.dart';
import 'package:Kootumb/models/follows_list.dart';
import 'package:Kootumb/models/hashtag.dart';
import 'package:Kootumb/models/post.dart';
import 'package:Kootumb/models/post_comment.dart';
import 'package:Kootumb/models/post_comment_reaction.dart';
import 'package:Kootumb/models/post_reaction.dart';
import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/pages/home/bottom_sheets/camera_picker.dart';
import 'package:Kootumb/pages/home/bottom_sheets/community_actions.dart';
import 'package:Kootumb/pages/home/bottom_sheets/community_type_picker.dart';
import 'package:Kootumb/pages/home/bottom_sheets/confirm_action.dart';
import 'package:Kootumb/pages/home/bottom_sheets/connection_circles_picker.dart';
import 'package:Kootumb/pages/home/bottom_sheets/follows_lists_picker.dart';
import 'package:Kootumb/pages/home/bottom_sheets/hashtag_actions.dart';
import 'package:Kootumb/pages/home/bottom_sheets/hashtags_display_setting_picker.dart';
import 'package:Kootumb/pages/home/bottom_sheets/image_picker.dart';
import 'package:Kootumb/pages/home/bottom_sheets/link_previews_setting_picker.dart';
import 'package:Kootumb/pages/home/bottom_sheets/post_actions.dart';
import 'package:Kootumb/pages/home/bottom_sheets/post_comment_more_actions.dart';
import 'package:Kootumb/pages/home/bottom_sheets/react_to_post.dart';
import 'package:Kootumb/pages/home/bottom_sheets/react_to_post_comment.dart';
import 'package:Kootumb/pages/home/bottom_sheets/user_actions/user_actions.dart';
import 'package:Kootumb/pages/home/bottom_sheets/user_visibility_picker.dart';
import 'package:Kootumb/pages/home/bottom_sheets/video_picker.dart';
import 'package:Kootumb/pages/home/bottom_sheets/videos_autoplay_setting_picker.dart';
import 'package:Kootumb/pages/home/bottom_sheets/videos_sound_setting_picker.dart';
import 'package:Kootumb/services/media/models/media_file.dart';
import 'package:Kootumb/services/user_preferences.dart';
import 'package:Kootumb/widgets/post/post.dart';
import 'package:flutter/material.dart';

class BottomSheetService {
  bool hasActiveBottomSheet = false;

  Future<PostReaction> showReactToPost({
    required Post post,
    required BuildContext context,
  }) async {
    return _showModalBottomSheetApp(
      context: context,
      builder: (BuildContext context) {
        return Material(child: OBReactToPostBottomSheet(post));
      },
    );
  }

  Future<PostCommentReaction> showReactToPostComment({
    required PostComment postComment,
    required Post post,
    required BuildContext context,
  }) async {
    return _showModalBottomSheetApp(
      context: context,
      builder: (BuildContext context) {
        return Material(
          child: OBReactToPostCommentBottomSheet(
            postComment: postComment,
            post: post,
          ),
        );
      },
    );
  }

  void showConnectionsCirclesPicker({
    required BuildContext context,
    required String title,
    required String actionLabel,
    required OnPickedCircles onPickedCircles,
    List<Circle>? initialPickedCircles,
  }) {
    _showModalBottomSheetApp(
      context: context,
      builder: (BuildContext context) {
        return OBConnectionCirclesPickerBottomSheet(
          initialPickedCircles: initialPickedCircles,
          title: title,
          actionLabel: actionLabel,
          onPickedCircles: onPickedCircles,
        );
      },
    );
  }

  Future<void> showCommunityTypePicker({
    required BuildContext context,
    ValueChanged<CommunityType>? onChanged,
    CommunityType? initialType,
  }) {
    return _showModalBottomSheetApp(
      context: context,
      builder: (BuildContext context) {
        return OBCommunityTypePickerBottomSheet(
          onTypeChanged: onChanged ?? (_) {},
          initialType: initialType,
        );
      },
    );
  }

  Future<void> showUserVisibilityPicker({required BuildContext context}) {
    return _showModalBottomSheetApp(
      context: context,
      builder: (BuildContext context) {
        return OBUserVisibilityPickerBottomSheet();
      },
    );
  }

  Future<void> showVideosSoundSettingPicker({
    required BuildContext context,
    ValueChanged<VideosSoundSetting>? onChanged,
    VideosSoundSetting? initialValue,
  }) {
    return _showModalBottomSheetApp(
      context: context,
      builder: (BuildContext context) {
        return OBVideosSoundSettingPickerBottomSheet(
          onTypeChanged: onChanged ?? (_) {},
          initialValue: initialValue,
        );
      },
    );
  }

  Future<void> showHashtagsDisplaySettingPicker({
    required BuildContext context,
    ValueChanged<HashtagsDisplaySetting>? onChanged,
    HashtagsDisplaySetting? initialValue,
  }) {
    return _showModalBottomSheetApp(
      context: context,
      builder: (BuildContext context) {
        return OBHashtagsDisplaySettingPickerBottomSheet(
          onTypeChanged: onChanged ?? (_) {},
          initialValue: initialValue,
        );
      },
    );
  }

  Future<void> showVideosAutoPlaySettingPicker({
    required BuildContext context,
    ValueChanged<VideosAutoPlaySetting>? onChanged,
    VideosAutoPlaySetting? initialValue,
  }) {
    return _showModalBottomSheetApp(
      context: context,
      builder: (BuildContext context) {
        return OBVideosAutoPlaySettingPickerBottomSheet(
          onTypeChanged: onChanged ?? (_) {},
          initialValue: initialValue,
        );
      },
    );
  }

  Future<void> showLinkPreviewsSettingPicker({
    required BuildContext context,
    ValueChanged<LinkPreviewsSetting>? onChanged,
    LinkPreviewsSetting? initialValue,
  }) {
    return _showModalBottomSheetApp(
      context: context,
      builder: (BuildContext context) {
        return OBLinkPreviewsSettingPickerBottomSheet(
          onTypeChanged: onChanged ?? (_) {},
          initialValue: initialValue,
        );
      },
    );
  }

  Future<List<FollowsList>?> showFollowsListsPicker({
    required BuildContext context,
    required String title,
    required String actionLabel,
    List<FollowsList>? initialPickedFollowsLists,
  }) {
    return _showModalBottomSheetApp(
      context: context,
      builder: (BuildContext context) {
        return OBFollowsListsPickerBottomSheet(
          initialPickedFollowsLists: initialPickedFollowsLists,
          title: title,
          actionLabel: actionLabel,
        );
      },
    );
  }

  Future<void> showPostActions({
    required BuildContext context,
    required Post post,
    required OBPostDisplayContext displayContext,
    required OnPostDeleted? onPostDeleted,
    required ValueChanged<Post>? onPostReported,
    ValueChanged<Community>? onPostCommunityExcludedFromProfilePosts,
    Function? onCommunityExcluded,
    Function? onUndoCommunityExcluded,
    List<FollowsList>? initialPickedFollowsLists,
  }) {
    return _showModalBottomSheetApp(
      context: context,
      builder: (BuildContext context) {
        return OBPostActionsBottomSheet(
          post: post,
          displayContext: displayContext,
          onCommunityExcluded: onCommunityExcluded,
          onUndoCommunityExcluded: onUndoCommunityExcluded,
          onPostCommunityExcludedFromProfilePosts:
              onPostCommunityExcludedFromProfilePosts,
          onPostDeleted: onPostDeleted ?? (_) {},
          onPostReported: onPostReported ?? (_) {},
        );
      },
    );
  }

  Future<void> showHashtagActions({
    required BuildContext context,
    required Hashtag hashtag,
    required ValueChanged<Hashtag> onHashtagReported,
  }) {
    return _showModalBottomSheetApp(
      context: context,
      builder: (BuildContext context) {
        return OBHashtagActionsBottomSheet(
          hashtag: hashtag,
          onHashtagReported: onHashtagReported,
        );
      },
    );
  }

  Future<void> showUserActions({
    required BuildContext context,
    required User user,
  }) {
    return _showModalBottomSheetApp(
      context: context,
      builder: (BuildContext context) {
        return OBUserActionsBottomSheet(user);
      },
    );
  }

  Future<void> showCommunityActions({
    required BuildContext context,
    required Community community,
    OnCommunityReported? onCommunityReported,
  }) {
    return _showModalBottomSheetApp(
      context: context,
      builder: (BuildContext context) {
        return OBCommunityActionsBottomSheet(
          community: community,
          onCommunityReported: onCommunityReported ?? (_) {},
        );
      },
    );
  }

  Future<void> showMoreCommentActions({
    required BuildContext context,
    required Post post,
    required PostComment postComment,
    required ValueChanged<PostComment>? onPostCommentDeleted,
    required ValueChanged<PostComment>? onPostCommentReported,
  }) {
    return _showModalBottomSheetApp(
      context: context,
      builder: (BuildContext context) {
        return OBPostCommentMoreActionsBottomSheet(
          onPostCommentReported: onPostCommentReported ?? (_) {},
          onPostCommentDeleted: onPostCommentDeleted ?? (_) {},
          post: post,
          postComment: postComment,
        );
      },
    );
  }

  Future<MediaFile> showCameraPicker({required BuildContext context}) {
    return _showModalBottomSheetApp(
      context: context,
      builder: (BuildContext context) {
        return OBCameraPickerBottomSheet();
      },
    );
  }

  Future<File> showVideoPicker({required BuildContext context}) {
    return _showModalBottomSheetApp(
      context: context,
      builder: (BuildContext context) {
        return OBVideoPickerBottomSheet();
      },
    );
  }

  Future<File> showImagePicker({required BuildContext context}) {
    return _showModalBottomSheetApp(
      context: context,
      builder: (BuildContext context) {
        return OBImagePickerBottomSheet();
      },
    );
  }

  Future<File> showConfirmAction({
    required BuildContext context,
    String? title,
    String? subtitle,
    String? description,
    String? confirmText,
    String? cancelText,
    required ActionCompleter actionCompleter,
  }) {
    return _showModalBottomSheetApp(
      context: context,
      builder: (BuildContext context) {
        return OBConfirmActionBottomSheet(
          title: title,
          subtitle: subtitle,
          description: description,
          confirmText: confirmText,
          cancelText: cancelText,
          actionCompleter: actionCompleter,
        );
      },
    );
  }

  void dismissActiveBottomSheet({required BuildContext context}) async {
    if (hasActiveBottomSheet) {
      Navigator.of(context, rootNavigator: true).pop();
      hasActiveBottomSheet = true;
    }
  }

  Future<T> _showModalBottomSheetApp<T>({
    required BuildContext context,
    required WidgetBuilder builder,
  }) async {
    dismissActiveBottomSheet(context: context);
    hasActiveBottomSheet = true;
    final result = await showModalBottomSheetApp(
      context: context,
      builder: builder,
    );
    hasActiveBottomSheet = false;
    return result;
  }
}

//Flutter Modal Bottom Sheet
//Modified by Suvadeep Das
//Based on https://gist.github.com/andrelsmoraes/9e4af0133bff8960c1feeb0ead7fd749

const Duration _kBottomSheetDuration = Duration(milliseconds: 200);

class _ModalBottomSheetLayout extends SingleChildLayoutDelegate {
  _ModalBottomSheetLayout(this.progress, this.bottomInset);

  final double progress;
  final double bottomInset;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
      minWidth: constraints.maxWidth,
      maxWidth: constraints.maxWidth,
      minHeight: 0.0,
      maxHeight: constraints.maxHeight,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    // Mega OPENBOOK HACK!
    return Offset(
      0.0,
      size.height -
          bottomInset +
          (bottomInset > 50 ? 50 : 0) -
          childSize.height * progress,
    );
  }

  @override
  bool shouldRelayout(_ModalBottomSheetLayout oldDelegate) {
    return progress != oldDelegate.progress ||
        bottomInset != oldDelegate.bottomInset;
  }
}

class _ModalBottomSheet<T> extends StatefulWidget {
  const _ModalBottomSheet({Key? key, required this.route}) : super(key: key);

  final _ModalBottomSheetRoute<T> route;

  @override
  _ModalBottomSheetState<T> createState() => _ModalBottomSheetState<T>();
}

class _ModalBottomSheetState<T> extends State<_ModalBottomSheet<T>> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.route.dismissOnTap ? () => Navigator.pop(context) : null,
      child: AnimatedBuilder(
        animation: widget.route.animation!,
        builder: (BuildContext context, Widget? child) {
          double bottomInset = widget.route.resizeToAvoidBottomPadding
              ? MediaQuery.of(context).viewInsets.bottom
              : 0.0;
          return ClipRect(
            child: CustomSingleChildLayout(
              delegate: _ModalBottomSheetLayout(
                widget.route.animation!.value,
                bottomInset,
              ),
              child: BottomSheet(
                animationController: widget.route._animationController,
                onClosing: () => Navigator.pop(context),
                builder: widget.route.builder!,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ModalBottomSheetRoute<T> extends PopupRoute<T> {
  _ModalBottomSheetRoute({
    this.builder,
    this.theme,
    this.barrierLabel,
    RouteSettings? settings,
    this.resizeToAvoidBottomPadding = false,
    this.dismissOnTap = false,
  }) : super(settings: settings);

  final WidgetBuilder? builder;
  final ThemeData? theme;
  final bool resizeToAvoidBottomPadding;
  final bool dismissOnTap;

  @override
  Duration get transitionDuration => _kBottomSheetDuration;

  @override
  bool get barrierDismissible => true;

  @override
  final String? barrierLabel;

  @override
  Color get barrierColor => Colors.black54;

  AnimationController? _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController = BottomSheet.createAnimationController(
      navigator!.overlay!,
    );
    return _animationController!;
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    // By definition, the bottom sheet is aligned to the bottom of the page
    // and isn't exposed to the top padding of the MediaQuery.
    Widget bottomSheet = MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: _ModalBottomSheet<T>(route: this),
    );
    if (theme != null) {
      bottomSheet = Theme(data: theme!, child: bottomSheet);
    }
    return bottomSheet;
  }
}

/// Shows a modal material design bottom sheet.
///
/// A modal bottom sheet is an alternative to a menu or a dialog and prevents
/// the user from interacting with the rest of the app.
///
/// A closely related widget is a persistent bottom sheet, which shows
/// information that supplements the primary content of the app without
/// preventing the use from interacting with the app. Persistent bottom sheets
/// can be created and displayed with the [showBottomSheet] function or the
/// [ScaffoldState.showBottomSheet] method.
///
/// The `context` argument is used to look up the [Navigator] and [Theme] for
/// the bottom sheet. It is only used when the method is called. Its
/// corresponding widget can be safely removed from the tree before the bottom
/// sheet is closed.
///
/// Returns a `Future` that resolves to the value (if any) that was passed to
/// [Navigator.pop] when the modal bottom sheet was closed.
///
/// See also:
///
///  * [BottomSheet], which is the widget normally returned by the function
///    passed as the `builder` argument to [showModalBottomSheet].
///  * [showBottomSheet] and [ScaffoldState.showBottomSheet], for showing
///    non-modal bottom sheets.
///  * <https://material.google.com/components/bottom-sheets.html#bottom-sheets-modal-bottom-sheets>
Future<T?> showModalBottomSheetApp<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool dismissOnTap = false,
  bool resizeToAvoidBottomPadding = true,
}) {
  return Navigator.of(context, rootNavigator: true).push(
    _ModalBottomSheetRoute<T>(
      builder: builder,
      theme: ThemeData(canvasColor: Colors.transparent),
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      resizeToAvoidBottomPadding: resizeToAvoidBottomPadding,
      dismissOnTap: dismissOnTap,
    ),
  );
}
