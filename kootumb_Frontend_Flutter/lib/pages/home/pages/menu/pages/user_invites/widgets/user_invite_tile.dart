import 'package:Kootumb/models/user_invite.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/services/toast.dart';
import 'package:Kootumb/services/user.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/theming/actionable_smart_text.dart';
import 'package:Kootumb/widgets/theming/secondary_text.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class OBUserInviteTile extends StatefulWidget {
  final UserInvite userInvite;
  final VoidCallback? onUserInviteDeletedCallback;

  const OBUserInviteTile(
      {required this.userInvite, Key? key, this.onUserInviteDeletedCallback})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBUserInviteTileState();
  }
}

class OBUserInviteTileState extends State<OBUserInviteTile> {
  late bool _requestInProgress;
  late UserService _userService;
  late ToastService _toastService;
  late LocalizationService _localizationService;

  CancelableOperation? _deleteOperation;

  @override
  void initState() {
    super.initState();
    _requestInProgress = false;
  }

  @override
  void dispose() {
    super.dispose();
    if (_deleteOperation != null) _deleteOperation!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var provider = KongoProvider.of(context);
    _userService = provider.userService;
    _toastService = provider.toastService;
    _localizationService = provider.localizationService;
    var navigationService = provider.navigationService;
    Widget tile;

    if (widget.userInvite.createdUser != null) {
      tile = ListTile(
          onTap: () {
            navigationService.navigateToUserProfile(
                user: widget.userInvite.createdUser!, context: context);
          },
          leading: const OBIcon(OBIcons.invite),
          title: OBText(
            widget.userInvite.nickname!,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: _buildActionableSecondaryText());
    } else {
      tile = Slidable(
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.25,
          children: [
            SlidableAction(
              onPressed: (context) => _deleteUserInvite(),
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: _localizationService.user__invites_delete,
            ),
          ],
        ),
        child: ListTile(
            onTap: () {
              navigationService.navigateToInviteDetailPage(
                  userInvite: widget.userInvite, context: context);
            },
            leading: const OBIcon(OBIcons.invite),
            title: OBText(
              widget.userInvite.nickname!,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: _buildActionableSecondaryText()),
      );
    }

    if (_requestInProgress) {
      tile = Opacity(opacity: 0.5, child: tile);
    }
    return tile;
  }

  Widget _buildActionableSecondaryText() {
    if (widget.userInvite.createdUser != null) {
      return OBActionableSmartText(
        size: OBTextSize.mediumSecondary,
        text: _localizationService.user__invites_joined_with(
            widget.userInvite.createdUser!.username!),
      );
    } else {
      return OBSecondaryText(_localizationService.user__invites_pending);
    }
  }

  void _deleteUserInvite() async {
    _setRequestInProgress(true);
    try {
      _deleteOperation = CancelableOperation.fromFuture(
          _userService.deleteUserInvite(widget.userInvite));
      await _deleteOperation!.value;
      _setRequestInProgress(false);
      if (widget.onUserInviteDeletedCallback != null) {
        widget.onUserInviteDeletedCallback!();
      }
    } catch (error) {
      _onError(error);
    } finally {
      _setRequestInProgress(false);
      _deleteOperation = null;
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

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }
}
