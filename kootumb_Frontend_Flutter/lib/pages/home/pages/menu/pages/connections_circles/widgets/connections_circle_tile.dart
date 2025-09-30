import 'package:Kootumb/libs/pretty_count.dart';
import 'package:Kootumb/models/circle.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/services/navigation_service.dart';
import 'package:Kootumb/services/toast.dart';
import 'package:Kootumb/services/user.dart';
import 'package:Kootumb/widgets/circle_color_preview.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:Kootumb/widgets/theming/secondary_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class OBConnectionsCircleTile extends StatefulWidget {
  final Circle connectionsCircle;
  final VoidCallback? onConnectionsCircleDeletedCallback;
  final bool isReadOnly;

  const OBConnectionsCircleTile(
      {required this.connectionsCircle,
      Key? key,
      this.onConnectionsCircleDeletedCallback,
      this.isReadOnly = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBConnectionsCircleTileState();
  }
}

class OBConnectionsCircleTileState extends State<OBConnectionsCircleTile> {
  late bool _requestInProgress;
  late UserService _userService;
  late ToastService _toastService;
  late NavigationService _navigationService;
  late LocalizationService _localizationService;

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
    _navigationService = provider.navigationService;
    _localizationService = provider.localizationService;

    Widget tile = _buildTile();

    if (widget.isReadOnly) return tile;

    tile = Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (context) => _deleteConnectionsCircle(),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: _localizationService.user__connections_circle_delete,
          ),
        ],
      ),
      child: tile,
    );

    if (_requestInProgress) {
      tile = Opacity(opacity: 0.5, child: tile);
    }
    return tile;
  }

  Widget _buildTile() {
    String prettyCount = getPrettyCount(
        widget.connectionsCircle.usersCount ?? 0, _localizationService);

    return ListTile(
        onTap: () {
          _navigationService.navigateToConnectionsCircle(
              connectionsCircle: widget.connectionsCircle, context: context);
        },
        leading: OBCircleColorPreview(
          widget.connectionsCircle,
          size: OBCircleColorPreviewSize.medium,
        ),
        title: OBText(
          widget.connectionsCircle.name!,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: OBSecondaryText(
            _localizationService.user__circle_peoples_count(prettyCount)));
  }

  void _deleteConnectionsCircle() async {
    _setRequestInProgress(true);
    try {
      await _userService.deleteConnectionsCircle(widget.connectionsCircle);
      // widget.post.decreaseCommentsCount();
      _setRequestInProgress(false);
      if (widget.onConnectionsCircleDeletedCallback != null) {
        widget.onConnectionsCircleDeletedCallback!();
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
