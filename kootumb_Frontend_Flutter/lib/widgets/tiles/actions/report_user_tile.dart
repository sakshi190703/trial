import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/services/navigation_service.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:Kootumb/widgets/tiles/loading_tile.dart';
import 'package:flutter/material.dart';

class OBReportUserTile extends StatefulWidget {
  final User user;
  final ValueChanged<dynamic>? onUserReported;
  final VoidCallback? onWantsToReportUser;

  const OBReportUserTile({
    Key? key,
    this.onUserReported,
    required this.user,
    this.onWantsToReportUser,
  }) : super(key: key);

  @override
  OBReportUserTileState createState() {
    return OBReportUserTileState();
  }
}

class OBReportUserTileState extends State<OBReportUserTile> {
  late NavigationService _navigationService;
  late bool _requestInProgress;

  @override
  void initState() {
    super.initState();
    _requestInProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    var kongoProvider = KongoProvider.of(context);
    _navigationService = kongoProvider.navigationService;
    LocalizationService localizationService = kongoProvider.localizationService;

    return StreamBuilder(
      stream: widget.user.updateSubject,
      initialData: widget.user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        var user = snapshot.data;

        bool isReported = user?.isReported ?? false;

        return OBLoadingTile(
          isLoading: _requestInProgress || isReported,
          leading: OBIcon(OBIcons.report),
          title: OBText(isReported
              ? localizationService.moderation__you_have_reported_account_text
              : localizationService.moderation__report_account_text),
          onTap: isReported ? () {} : _reportUser,
        );
      },
    );
  }

  void _reportUser() {
    if (widget.onWantsToReportUser != null) widget.onWantsToReportUser!();
    _navigationService.navigateToReportObject(
        context: context,
        object: widget.user,
        onObjectReported: widget.onUserReported);
  }
}
