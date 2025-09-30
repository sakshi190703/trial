import 'package:Kootumb/models/emoji.dart';
import 'package:Kootumb/models/emoji_group.dart';
import 'package:Kootumb/models/post.dart';
import 'package:Kootumb/models/post_reaction.dart';
import 'package:Kootumb/pages/home/bottom_sheets/rounded_bottom_sheet.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/toast.dart';
import 'package:Kootumb/services/user.dart';
import 'package:Kootumb/widgets/emoji_picker/emoji_picker.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBReactToPostBottomSheet extends StatefulWidget {
  final Post post;

  const OBReactToPostBottomSheet(this.post, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBReactToPostBottomSheetState();
  }
}

class OBReactToPostBottomSheetState extends State<OBReactToPostBottomSheet> {
  late UserService _userService;
  late ToastService _toastService;

  late bool _isReactToPostInProgress;
  CancelableOperation? _reactOperation;

  @override
  void initState() {
    super.initState();
    _isReactToPostInProgress = false;
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
              ignoring: _isReactToPostInProgress,
              child: Opacity(
                opacity: _isReactToPostInProgress ? 0.5 : 1,
                child: OBEmojiPicker(
                  hasSearch: false,
                  isReactionsPicker: true,
                  onEmojiPicked: _reactToPost,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _reactToPost(Emoji emoji, EmojiGroup? emojiGroup) async {
    if (_isReactToPostInProgress) return;
    _setReactToPostInProgress(true);

    try {
      _reactOperation = CancelableOperation.fromFuture(
          _userService.reactToPost(post: widget.post, emoji: emoji));

      PostReaction postReaction = await _reactOperation!.value;
      widget.post.setReaction(postReaction);
      // Remove modal
      Navigator.pop(context);
      _setReactToPostInProgress(false);
    } catch (error) {
      _onError(error);
      _setReactToPostInProgress(false);
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

  void _setReactToPostInProgress(bool reactToPostInProgress) {
    setState(() {
      _isReactToPostInProgress = reactToPostInProgress;
    });
  }
}

typedef OnPostCreatedCallback = void Function(PostReaction reaction);
