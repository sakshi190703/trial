import 'package:Kootumb/models/follows_list.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/toast.dart';
import 'package:Kootumb/services/user.dart';
import 'package:Kootumb/widgets/theming/secondary_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class OBFollowsListTile extends StatefulWidget {
  final FollowsList followsList;
  final VoidCallback? onFollowsListDeletedCallback;

  const OBFollowsListTile(
      {required this.followsList,
      Key? key,
      this.onFollowsListDeletedCallback,
      required bool isSelected,
      required void Function(FollowsList pressedFollowsList)
          onFollowsListPressed})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBFollowsListTileState();
  }
}

class OBFollowsListTileState extends State<OBFollowsListTile> {
  late bool _requestInProgress;
  late UserService _userService;
  late ToastService _toastService;

  @override
  void initState() {
    super.initState();
    _requestInProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    var provider = KongoProvider.of(context);
    _userService = provider.userService;
    _toastService = provider.toastService;

    Widget tile = Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => _deleteFollowsList(),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        onTap: () {
          // Removed secondaryActions as ActionPane handles actions now
        },
        subtitle: OBSecondaryText('${widget.followsList.followsCount} users'),
      ),
    );

    if (_requestInProgress) {
      tile = Opacity(opacity: 0.5, child: tile);
    }
    return tile;
  }

  void _deleteFollowsList() async {
    _setRequestInProgress(true);
    try {
      await _userService.deleteFollowsList(widget.followsList);
      // widget.post.decreaseCommentsCount();
      _setRequestInProgress(false);
      if (widget.onFollowsListDeletedCallback != null) {
        widget.onFollowsListDeletedCallback!();
      }
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

  void _setRequestInProgress(bool value) {
    setState(() {
      _requestInProgress = value;
    });
  }
}
