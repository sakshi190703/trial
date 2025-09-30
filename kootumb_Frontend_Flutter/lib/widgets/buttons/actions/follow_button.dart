import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/services/toast.dart';
import 'package:Kootumb/services/user.dart';
import 'package:Kootumb/widgets/buttons/button.dart';
export 'package:Kootumb/widgets/buttons/button.dart';
import 'package:flutter/material.dart';

class OBFollowButton extends StatefulWidget {
  final User user;
  final OBButtonSize size;
  final OBButtonType unfollowButtonType;

  const OBFollowButton(this.user,
      {Key? key,
      this.size = OBButtonSize.medium,
      this.unfollowButtonType = OBButtonType.primary})
      : super(key: key);

  @override
  OBFollowButtonState createState() {
    return OBFollowButtonState();
  }
}

class OBFollowButtonState extends State<OBFollowButton> {
  late UserService _userService;
  late ToastService _toastService;
  late LocalizationService _localizationService;
  late bool _requestInProgress;

  @override
  void initState() {
    super.initState();
    _requestInProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    var kongoProvider = KongoProvider.of(context);
    _userService = kongoProvider.userService;
    _toastService = kongoProvider.toastService;
    _localizationService = kongoProvider.localizationService;

    return StreamBuilder(
      stream: widget.user.updateSubject,
      initialData: widget.user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        var user = snapshot.data;

        if (user?.isFollowing == null) return const SizedBox();

        return (user?.isFollowing ?? false)
            ? _buildUnfollowButton()
            : (user?.visibility != UserVisibility.private) ||
                    (user?.isFollowing ?? false)
                ? _buildFollowButton()
                : _buildRequestToFollowButton();
      },
    );
  }

  Widget _buildRequestToFollowButton() {
    if (widget.user.isFollowRequested == null) return const SizedBox();

    final followButtonText = widget.user.isFollowRequested == true
        ? _localizationService.user__follow_button_requested_to_follow_text
        : getFollowButtonText();

    return OBButton(
      size: widget.size,
      isLoading: _requestInProgress,
      onPressed: widget.user.isFollowRequested == true
          ? _cancelRequestToFollowUser
          : _requestToFollowUser,
      child: Text(
        followButtonText,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildFollowButton() {
    final followButtonText = getFollowButtonText();

    return OBButton(
      size: widget.size,
      isLoading: _requestInProgress,
      onPressed: _followUser,
      child: Text(
        followButtonText,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildUnfollowButton() {
    return OBButton(
      size: widget.size,
      isLoading: _requestInProgress,
      onPressed: _unFollowUser,
      type: widget.unfollowButtonType,
      child: Text(
        _localizationService.user__follow_button_following_text,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  void _followUser() async {
    _setRequestInProgress(true);
    try {
      await _userService.followUserWithUsername(widget.user.username!);
      widget.user.incrementFollowersCount();
    } catch (error) {
      _onError(error);
    } finally {
      _setRequestInProgress(false);
    }
  }

  void _requestToFollowUser() async {
    _setRequestInProgress(true);
    try {
      await _userService.requestToFollowUser(widget.user);
      widget.user.setIsFollowRequested(true);
    } catch (error) {
      _onError(error);
    } finally {
      _setRequestInProgress(false);
    }
  }

  void _cancelRequestToFollowUser() async {
    _setRequestInProgress(true);
    try {
      await _userService.cancelRequestToFollowUser(widget.user);
      widget.user.setIsFollowRequested(false);
    } catch (error) {
      _onError(error);
    } finally {
      _setRequestInProgress(false);
    }
  }

  void _unFollowUser() async {
    _setRequestInProgress(true);
    try {
      await _userService.unFollowUserWithUsername(widget.user.username!);
      widget.user.decrementFollowersCount();
    } catch (error) {
      _onError(error);
    } finally {
      _setRequestInProgress(false);
    }
  }

  String getFollowButtonText() {
    return widget.user.isFollowed != null && widget.user.isFollowed!
        ? _localizationService.user__follow_button_follow_back_text
        : _localizationService.user__follow_button_follow_text;
  }

  void _onError(error) async {
    if (error is HttpieConnectionRefusedError) {
      _toastService.error(
          message: error.toHumanReadableMessage(), context: context);
    } else if (error is HttpieRequestError) {
      String? errorMessage = await error.toHumanReadableMessage();
      _toastService.error(
          message: errorMessage ?? _localizationService.error__unknown_error,
          context: context);
    } else {
      _toastService.error(
          message: _localizationService.error__unknown_error, context: context);
      throw error;
    }
  }

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }
}
