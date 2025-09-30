import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/toast.dart';
import 'package:Kootumb/services/user.dart';
import 'package:Kootumb/widgets/buttons/button.dart';
export 'package:Kootumb/widgets/buttons/button.dart';
import 'package:flutter/material.dart';

class OBBlockButton extends StatefulWidget {
  final User user;
  final OBButtonSize size;

  const OBBlockButton(this.user, {Key? key, this.size = OBButtonSize.medium})
      : super(key: key);

  @override
  OBBlockButtonState createState() {
    return OBBlockButtonState();
  }
}

class OBBlockButtonState extends State<OBBlockButton> {
  late UserService _userService;
  late ToastService _toastService;
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

    return StreamBuilder(
      stream: widget.user.updateSubject,
      initialData: widget.user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        var user = snapshot.data!;
        bool isBlocked = user.isBlocked ?? false;

        return isBlocked ? _buildUnblockButton() : _buildBlockButton();
      },
    );
  }

  Widget _buildBlockButton() {
    return OBButton(
      size: widget.size,
      isLoading: _requestInProgress,
      onPressed: _blockUser,
      child: Text(
        'Block',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildUnblockButton() {
    return OBButton(
      size: widget.size,
      isLoading: _requestInProgress,
      onPressed: _unBlockUser,
      type: OBButtonType.danger,
      child: Text(
        'Unblock',
      ),
    );
  }

  void _blockUser() async {
    _setRequestInProgress(true);
    try {
      await _userService.blockUser(widget.user);
    } catch (error) {
      _onError(error);
    } finally {
      _setRequestInProgress(false);
    }
  }

  void _unBlockUser() async {
    _setRequestInProgress(true);
    try {
      await _userService.unblockUser(widget.user);
    } catch (error) {
      _onError(error);
    } finally {
      _setRequestInProgress(false);
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

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }
}
