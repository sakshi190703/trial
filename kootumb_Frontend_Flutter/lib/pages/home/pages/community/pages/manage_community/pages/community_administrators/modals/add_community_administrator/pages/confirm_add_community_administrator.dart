import 'package:Kootumb/models/community.dart';
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

class OBConfirmAddCommunityAdministrator<T> extends StatefulWidget {
  final User user;
  final Community community;

  const OBConfirmAddCommunityAdministrator(
      {Key? key, required this.user, required this.community})
      : super(key: key);

  @override
  OBConfirmAddCommunityAdministratorState createState() {
    return OBConfirmAddCommunityAdministratorState();
  }
}

class OBConfirmAddCommunityAdministratorState
    extends State<OBConfirmAddCommunityAdministrator> {
  late bool _confirmationInProgress;
  late UserService _userService;
  late LocalizationService _localizationService;
  late ToastService _toastService;
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

    String adminDescriptionText =
        _localizationService.trans('community__admin_desc');
    String adminConfirmationText =
        _localizationService.community__admin_add_confirmation(username);

    return CupertinoPageScaffold(
        navigationBar: OBThemedNavigationBar(
            title: _localizationService.trans('community__confirmation_title')),
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
                      OBIcons.communityAdministrators,
                      themeColor: OBIconThemeColor.primaryAccent,
                      size: OBIconSize.extraLarge,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    OBText(
                      adminConfirmationText,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    OBText(
                      adminDescriptionText,
                      textAlign: TextAlign.center,
                    )
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
                      child: Text(_localizationService.trans('community__no')),
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
                      child: Text(_localizationService.trans('community__yes')),
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
      await _userService.addCommunityAdministrator(
          community: widget.community, user: widget.user);
      Navigator.of(context).pop(true);
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
          message: errorMessage ??
              _localizationService.trans('error__unknown_error'),
          context: context);
    } else {
      _toastService.error(
          message: _localizationService.trans('error__unknown_error'),
          context: context);
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
