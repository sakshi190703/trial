import 'package:Kootumb/models/moderation/moderated_object.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/services/toast.dart';
import 'package:Kootumb/services/user.dart';
import 'package:Kootumb/widgets/buttons/button.dart';
import 'package:Kootumb/widgets/checkbox.dart';
import 'package:Kootumb/widgets/moderated_object_status_circle.dart';
import 'package:Kootumb/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/widgets/page_scaffold.dart';
import 'package:Kootumb/widgets/progress_indicator.dart';
import 'package:Kootumb/widgets/theming/primary_color_container.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBModeratedObjectUpdateStatusModal extends StatefulWidget {
  final ModeratedObject moderatedObject;

  const OBModeratedObjectUpdateStatusModal(
      {Key? key, required this.moderatedObject})
      : super(key: key);

  @override
  OBModeratedObjectUpdateStatusModalState createState() {
    return OBModeratedObjectUpdateStatusModalState();
  }
}

class OBModeratedObjectUpdateStatusModalState
    extends State<OBModeratedObjectUpdateStatusModal> {
  late UserService _userService;
  late LocalizationService _localizationService;
  late ToastService _toastService;
  final List<ModeratedObjectStatus> _moderationStatuses = [
    ModeratedObjectStatus.rejected,
    ModeratedObjectStatus.approved,
  ];
  late ModeratedObjectStatus _selectedModerationStatus;
  late bool _needsBootstrap;
  late bool _requestInProgress;

  CancelableOperation? _updateStatusOperation;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _requestInProgress = false;
    _selectedModerationStatus = widget.moderatedObject.status!;
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var kongoProvider = KongoProvider.of(context);
      _toastService = kongoProvider.toastService;
      _userService = kongoProvider.userService;
      _localizationService = kongoProvider.localizationService;
      _needsBootstrap = false;
    }

    return OBCupertinoPageScaffold(
        navigationBar: _buildNavigationBar(),
        child: OBPrimaryColorContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _moderationStatuses.isEmpty
                  ? _buildProgressIndicator()
                  : _buildModerationStatuses(),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    if (_updateStatusOperation != null) _updateStatusOperation!.cancel();
  }

  Widget _buildProgressIndicator() {
    return Expanded(
      child: Center(
        child: OBProgressIndicator(),
      ),
    );
  }

  Widget _buildModerationStatuses() {
    return Expanded(
      child: ListView.separated(
        itemBuilder: _buildModerationStatusTile,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        separatorBuilder: (context, index) {
          return const Divider();
        },
        itemCount: _moderationStatuses.length,
      ),
    );
  }

  Widget _buildModerationStatusTile(context, index) {
    ModeratedObjectStatus status = _moderationStatuses[index];
    String statusString = ModeratedObject.factory
        .convertStatusToHumanReadableString(status, capitalize: true)!;

    return GestureDetector(
      key: Key(statusString),
      onTap: () => _setSelectedModerationStatus(status),
      child: Row(
        children: <Widget>[
          Expanded(
            child: ListTile(
              title: Row(
                children: <Widget>[
                  OBModeratedObjectStatusCircle(
                    status: status,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  OBText(
                    statusString,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
              //trailing: OBIcon(OBIcons.chevronRight),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: OBCheckbox(
              value: _selectedModerationStatus == status,
            ),
          )
        ],
      ),
    );
  }

  void _setSelectedModerationStatus(ModeratedObjectStatus status) {
    setState(() {
      _selectedModerationStatus = status;
    });
  }

  void _saveModerationStatus() async {
    _setRequestInProgress(true);
    try {
      if (_selectedModerationStatus == widget.moderatedObject.status) {
        Navigator.of(context).pop();
        return;
      }

      switch (_selectedModerationStatus) {
        case ModeratedObjectStatus.approved:
          _updateStatusOperation = CancelableOperation.fromFuture(
              _userService.approveModeratedObject(widget.moderatedObject));
          break;
        case ModeratedObjectStatus.rejected:
          _updateStatusOperation = CancelableOperation.fromFuture(
              _userService.rejectModeratedObject(widget.moderatedObject));
          break;
        default:
          throw 'Unsuppported update type';
      }
      await _updateStatusOperation?.value;
      Navigator.of(context).pop(_selectedModerationStatus);
      widget.moderatedObject.setStatus(_selectedModerationStatus);
    } catch (error) {
      _onError(error);
    } finally {
      _updateStatusOperation = null;
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

  ObstructingPreferredSizeWidget _buildNavigationBar() {
    return OBThemedNavigationBar(
      title: _localizationService.trans('moderation__update_status_title'),
      trailing: OBButton(
        isLoading: _requestInProgress,
        size: OBButtonSize.small,
        onPressed: _saveModerationStatus,
        child:
            Text(_localizationService.trans('moderation__update_status_save')),
      ),
    );
  }

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }
}

typedef OnObjectReported = Function(dynamic object);
