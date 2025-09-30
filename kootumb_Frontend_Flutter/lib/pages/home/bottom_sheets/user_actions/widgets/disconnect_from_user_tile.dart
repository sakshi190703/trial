import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/services/toast.dart';
import 'package:Kootumb/services/user.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBDisconnectFromUserTile extends StatefulWidget {
  final User user;
  final String? title;
  final VoidCallback onDisconnectedFromUser;

  const OBDisconnectFromUserTile(this.user,
      {Key? key, this.title, required this.onDisconnectedFromUser})
      : super(key: key);

  @override
  OBDisconnectFromUserTileState createState() {
    return OBDisconnectFromUserTileState();
  }
}

class OBDisconnectFromUserTileState extends State<OBDisconnectFromUserTile> {
  late UserService _userService;
  late ToastService _toastService;
  late LocalizationService _localizationService;

  @override
  Widget build(BuildContext context) {
    var kongoProvider = KongoProvider.of(context);
    _userService = kongoProvider.userService;
    _toastService = kongoProvider.toastService;
    _localizationService = kongoProvider.localizationService;

    String userName = widget.user.getProfileName()!;

    return ListTile(
        title: OBText(widget.title ??
            _localizationService.user__disconnect_from_user(userName)),
        leading: const OBIcon(OBIcons.disconnect),
        onTap: () async {
          await _disconnectFromUser();
          widget.onDisconnectedFromUser();
        });
  }

  Future _disconnectFromUser() async {
    try {
      await _userService.disconnectFromUserWithUsername(widget.user.username!);
      widget.user.decrementFollowersCount();
      _toastService.success(
          message: _localizationService.user__disconnect_from_user_success,
          context: context);
    } catch (error) {
      _onError(error);
    }
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
}
