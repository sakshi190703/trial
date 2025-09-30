import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/services/toast.dart';
import 'package:Kootumb/services/user.dart';
import 'package:Kootumb/widgets/buttons/button.dart';
import 'package:flutter/material.dart';

class OBDenyConnectionButton extends StatefulWidget {
  final User user;

  const OBDenyConnectionButton(this.user, {Key? key}) : super(key: key);

  @override
  OBDenyConnectionButtonState createState() {
    return OBDenyConnectionButtonState();
  }
}

class OBDenyConnectionButtonState extends State<OBDenyConnectionButton> {
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

        if (user?.isPendingConnectionConfirmation == null ||
            user?.isConnected == false ||
            user?.isPendingConnectionConfirmation == false) {
          return const SizedBox();
        }

        return _buildDenyConnectionButton();
      },
    );
  }

  Widget _buildDenyConnectionButton() {
    return OBButton(
      isLoading: _requestInProgress,
      onPressed: _disconnectFromUser,
      type: OBButtonType.danger,
      child: Text(
        _localizationService.user__profile_action_deny_connection_short,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
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

  void _onError(error) async {
    if (error is HttpieConnectionRefusedError) {
      _toastService.error(
          message: error.toHumanReadableMessage(), context: context);
    } else if (error is HttpieRequestError) {
      String? errorMessage = await error.toHumanReadableMessage();
      _toastService.error(
          message: errorMessage ?? 'Unknown service', context: context);
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
