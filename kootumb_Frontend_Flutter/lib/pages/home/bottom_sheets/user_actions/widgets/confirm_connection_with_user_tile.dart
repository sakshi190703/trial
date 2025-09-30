import 'package:Kootumb/models/circle.dart';
import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/bottom_sheet.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/services/toast.dart';
import 'package:Kootumb/services/user.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBConfirmConnectionWithUserTile extends StatefulWidget {
  final User user;
  final VoidCallback? onWillShowModalBottomSheet;

  const OBConfirmConnectionWithUserTile(this.user,
      {Key? key, this.onWillShowModalBottomSheet})
      : super(key: key);

  @override
  OBConfirmConnectionWithUserTileState createState() {
    return OBConfirmConnectionWithUserTileState();
  }
}

class OBConfirmConnectionWithUserTileState
    extends State<OBConfirmConnectionWithUserTile> {
  late UserService _userService;
  late ToastService _toastService;
  late LocalizationService _localizationService;
  late BottomSheetService _bottomSheetService;

  @override
  Widget build(BuildContext context) {
    var kongoProvider = KongoProvider.of(context);
    _userService = kongoProvider.userService;
    _toastService = kongoProvider.toastService;
    _localizationService = kongoProvider.localizationService;
    _bottomSheetService = kongoProvider.bottomSheetService;

    String userName = widget.user.getProfileName()!;

    return ListTile(
        title: OBText(
            _localizationService.user__confirm_connection_with(userName)),
        leading: const OBIcon(OBIcons.check),
        onTap: _displayAddConnectionToCirclesBottomSheet);
  }

  void _displayAddConnectionToCirclesBottomSheet() {
    if (widget.onWillShowModalBottomSheet != null) {
      widget.onWillShowModalBottomSheet!();
    }
    _bottomSheetService.showConnectionsCirclesPicker(
        context: context,
        title: _localizationService
            .trans('user__confirm_connection_add_connection'),
        actionLabel:
            _localizationService.trans('user__confirm_connection_confirm_text'),
        onPickedCircles: _onWantsToAddConnectionToCircles);
  }

  Future _onWantsToAddConnectionToCircles(List<Circle> circles) async {
    await _confirmConnectionWithUser(circles);
  }

  Future _confirmConnectionWithUser(List<Circle> circles) async {
    try {
      await _userService.confirmConnectionWithUserWithUsername(
          widget.user.username!,
          circles: circles);
      if (!widget.user.isFollowing!) widget.user.incrementFollowersCount();
      _toastService.success(
          message: _localizationService
              .trans('user__confirm_connection_connection_confirmed'),
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
}
