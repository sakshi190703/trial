import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/services/toast.dart';
import 'package:Kootumb/services/user.dart';
import 'package:Kootumb/widgets/buttons/button.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Kootumb/widgets/theming/primary_color_container.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';

class OBConfirmBlockUserModal<T> extends StatefulWidget {
  final User user;

  const OBConfirmBlockUserModal({Key? key, required this.user})
      : super(key: key);

  @override
  OBConfirmBlockUserModalState createState() {
    return OBConfirmBlockUserModalState();
  }
}

class OBConfirmBlockUserModalState extends State<OBConfirmBlockUserModal> {
  late bool _confirmationInProgress;
  late UserService _userService;
  late ToastService _toastService;
  late LocalizationService _localizationService;
  late bool _needsBootstrap;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _confirmationInProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    String username = widget.user.username!;

    if (_needsBootstrap) {
      KongoProviderState kongoProvider = KongoProvider.of(context);
      _userService = kongoProvider.userService;
      _toastService = kongoProvider.toastService;
      _localizationService = kongoProvider.localizationService;
      _needsBootstrap = false;
    }

    return CupertinoPageScaffold(
        navigationBar: OBThemedNavigationBar(
            title: _localizationService.user__confirm_block_user_title),
        child: OBPrimaryColorContainer(
            child: Column(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    OBIcon(
                      OBIcons.block,
                      themeColor: OBIconThemeColor.primaryAccent,
                      size: OBIconSize.extraLarge,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    OBText(
                      _localizationService
                          .user__confirm_block_user_question(username),
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    OBText(_localizationService.user__confirm_block_user_info)
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: OBButton(
                      size: OBButtonSize.large,
                      type: OBButtonType.highlight,
                      onPressed: _onCancel,
                      child: Text(
                          _localizationService.user__confirm_block_user_no),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: OBButton(
                      size: OBButtonSize.large,
                      onPressed: _onConfirm,
                      isLoading: _confirmationInProgress,
                      child: Text(
                          _localizationService.user__confirm_block_user_yes),
                    ),
                  )
                ],
              ),
            )
          ],
        )));
  }

  void _onConfirm() async {
    _setConfirmationInProgress(true);
    try {
      await _userService.blockUser(widget.user);
      Navigator.of(context).pop(true);
      _toastService.success(
          message: _localizationService.user__confirm_block_user_blocked,
          context: context);
    } catch (error) {
      _onError(error);
    } finally {
      _setConfirmationInProgress(false);
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

  void _onCancel() {
    Navigator.of(context).pop(false);
  }

  void _setConfirmationInProgress(confirmationInProgress) {
    setState(() {
      _confirmationInProgress = confirmationInProgress;
    });
  }
}
