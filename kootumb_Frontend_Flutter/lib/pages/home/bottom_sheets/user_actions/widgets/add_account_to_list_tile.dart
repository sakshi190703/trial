import 'package:Kootumb/models/follows_list.dart';
import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/bottom_sheet.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/services/toast.dart';
import 'package:Kootumb/services/user.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBAddAccountToList extends StatefulWidget {
  final User user;
  final VoidCallback? onWillShowModalBottomSheet;

  const OBAddAccountToList(this.user,
      {Key? key, this.onWillShowModalBottomSheet})
      : super(key: key);

  @override
  OBAddAccountToListState createState() {
    return OBAddAccountToListState();
  }
}

class OBAddAccountToListState extends State<OBAddAccountToList> {
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

    bool hasFollowLists = widget.user.hasFollowLists();

    return ListTile(
        title: OBText(hasFollowLists
            ? _localizationService.user__add_account_update_account_lists
            : _localizationService.user__add_account_to_lists),
        leading: OBIcon(hasFollowLists ? OBIcons.lists : OBIcons.addToList),
        onTap: _displayAddConnectionToFollowsListsBottomSheet);
  }

  void _displayAddConnectionToFollowsListsBottomSheet() async {
    if (widget.onWillShowModalBottomSheet != null) {
      widget.onWillShowModalBottomSheet!();
    }

    var initialPickedLists = widget.user.followLists?.lists;

    bool hasFollowLists = widget.user.hasFollowLists();

    var pickedFollowsLists = await _bottomSheetService.showFollowsListsPicker(
        context: context,
        title: hasFollowLists
            ? _localizationService.user__add_account_update_lists
            : _localizationService.user__add_account_to_lists,
        actionLabel: hasFollowLists
            ? _localizationService.user__add_account_save
            : _localizationService.user__add_account_done,
        initialPickedFollowsLists: initialPickedLists);

    if (pickedFollowsLists != null) {
      _onWantsToFollowUserInLists(pickedFollowsLists);
    }
  }

  Future _onWantsToFollowUserInLists(List<FollowsList> followsLists) async {
    await _connectUserInFollowsLists(followsLists);
  }

  Future _connectUserInFollowsLists(List<FollowsList> followsLists) async {
    bool isAlreadyFollowingUser = widget.user.isFollowing ?? false;

    try {
      await (isAlreadyFollowingUser
          ? _userService.updateFollowWithUsername(widget.user.username!,
              followsLists: followsLists)
          : _userService.followUserWithUsername(widget.user.username!,
              followsLists: followsLists));
      if (!isAlreadyFollowingUser) {
        widget.user.incrementFollowersCount();
      }
      _toastService.success(
          message: _localizationService.user__add_account_success,
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
