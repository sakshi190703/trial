import 'package:Kootumb/models/emoji.dart';
import 'package:Kootumb/models/emoji_group.dart';
import 'package:Kootumb/models/post.dart';
import 'package:Kootumb/models/post_comment.dart';
import 'package:Kootumb/models/post_comment_reaction.dart';
import 'package:Kootumb/pages/home/bottom_sheets/rounded_bottom_sheet.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/toast.dart';
import 'package:Kootumb/services/user.dart';
import 'package:Kootumb/widgets/emoji_picker/emoji_picker.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBReactToPostCommentBottomSheet extends StatefulWidget {
  final PostComment postComment;
  final Post post;

  const OBReactToPostCommentBottomSheet(
      {Key? key, required this.post, required this.postComment})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBReactToPostCommentBottomSheetState();
  }
}

class OBReactToPostCommentBottomSheetState
    extends State<OBReactToPostCommentBottomSheet> {
  late UserService _userService;
  late ToastService _toastService;

  late bool _isReactToPostCommentInProgress;
  CancelableOperation? _reactOperation;

  @override
  void initState() {
    super.initState();
    _isReactToPostCommentInProgress = false;
  }

  @override
  void dispose() {
    super.dispose();
    if (_reactOperation != null) _reactOperation!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var kongoProvider = KongoProvider.of(context);
    _userService = kongoProvider.userService;
    _toastService = kongoProvider.toastService;

    double screenHeight = MediaQuery.of(context).size.height;

    return OBRoundedBottomSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: screenHeight / 3,
            child: IgnorePointer(
              ignoring: _isReactToPostCommentInProgress,
              child: Opacity(
                opacity: _isReactToPostCommentInProgress ? 0.5 : 1,
                child: OBEmojiPicker(
                  hasSearch: false,
                  isReactionsPicker: true,
                  onEmojiPicked: _reactToPostComment,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _reactToPostComment(Emoji emoji, EmojiGroup? emojiGroup) async {
    if (_isReactToPostCommentInProgress) return;
    _setReactToPostCommentInProgress(true);

    try {
      _reactOperation = CancelableOperation.fromFuture(
          _userService.reactToPostComment(
              post: widget.post,
              postComment: widget.postComment,
              emoji: emoji));

      PostCommentReaction postCommentReaction = await _reactOperation!.value;
      widget.postComment.setReaction(postCommentReaction);
      // Remove modal
      Navigator.pop(context);
      _setReactToPostCommentInProgress(false);
    } catch (error) {
      _onError(error);
      _setReactToPostCommentInProgress(false);
    } finally {
      _reactOperation = null;
    }
  }

  void _onError(error) async {
    if (error is HttpieConnectionRefusedError) {
      _toastService.error(
          message: error.toHumanReadableMessage(), context: context);
    } else if (error is HttpieRequestError) {
      String? errorMessage = await error.toHumanReadableMessage();
      _toastService.error(
          message: errorMessage ?? 'Unknown error', context: context);
    } else {
      _toastService.error(message: 'Unknown error', context: context);
      throw error;
    }
  }

  void _setReactToPostCommentInProgress(bool reactToPostCommentInProgress) {
    setState(() {
      _isReactToPostCommentInProgress = reactToPostCommentInProgress;
    });
  }
}

typedef OnPostCommentCreatedCallback = void Function(
    PostCommentReaction reaction);
