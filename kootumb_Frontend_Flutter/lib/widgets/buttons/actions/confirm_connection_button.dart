import 'package:Kootumb/models/circle.dart';
import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/bottom_sheet.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/services/toast.dart';
import 'package:Kootumb/services/user.dart';
import 'package:Kootumb/widgets/buttons/button.dart';
import 'package:flutter/material.dart';

class OBConfirmConnectionButton extends StatefulWidget {
  final User user;

  const OBConfirmConnectionButton(this.user, {Key? key}) : super(key: key);

  @override
  OBConfirmConnectionButtonState createState() {
    return OBConfirmConnectionButtonState();
  }
}

class OBConfirmConnectionButtonState extends State<OBConfirmConnectionButton> {
  late UserService _userService;
  late ToastService _toastService;
  late BottomSheetService _bottomSheetService;
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
    _bottomSheetService = kongoProvider.bottomSheetService;
    _localizationService = kongoProvider.localizationService;

    return StreamBuilder(
      stream: widget.user.updateSubject,
      initialData: widget.user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        var user = snapshot.data;

        if (user?.isPendingConnectionConfirmation == null ||
            user?.isConnected == false) {
          return const SizedBox();
        }

        return user?.isPendingConnectionConfirmation == true
            ? _buildConfirmConnectionButton()
            : _buildDisconnectButton();
      },
    );
  }

  Widget _buildConfirmConnectionButton() {
    return OBButton(
      isLoading: _requestInProgress,
      onPressed: _onWantsToConnectWithUser,
      type: OBButtonType.success,
      child: Text(
        _localizationService.user__profile_action_confirm_connection_short,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDisconnectButton() {
    return OBButton(
      isLoading: _requestInProgress,
      onPressed: _disconnectFromUser,
      type: OBButtonType.danger,
      child: Text(
        'Disconnect',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  void _onWantsToConnectWithUser() {
    _bottomSheetService.showConnectionsCirclesPicker(
        context: context,
        title: 'Confirm connection',
        actionLabel: 'Connect',
        onPickedCircles: _confirmConnectionWithUser);
  }

  Future _confirmConnectionWithUser(List<Circle> circles) async {
    if (_requestInProgress) return;
    _setRequestInProgress(true);
    try {
      await _userService.confirmConnectionWithUserWithUsername(
          widget.user.username!,
          circles: circles);
      if (!widget.user.isFollowing!) widget.user.incrementFollowersCount();
      _toastService.success(message: 'Connection confirmed', context: context);
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

  Future _disconnectFromUser() async {
    if (_requestInProgress) return;
    _setRequestInProgress(true);
    try {
      await _userService.disconnectFromUserWithUsername(widget.user.username!);
      widget.user.decrementFollowersCount();
      _toastService.success(
          message: 'Disconnected successfully', context: context);
    } catch (error) {
      _onError(error);
    } finally {
      _setRequestInProgress(false);
    }
  }

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }
}
