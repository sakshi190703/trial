import 'package:Kootumb/models/community.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/services/navigation_service.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:Kootumb/widgets/tiles/loading_tile.dart';
import 'package:flutter/material.dart';

class OBReportCommunityTile extends StatefulWidget {
  final Community community;
  final ValueChanged<dynamic>? onCommunityReported;
  final VoidCallback? onWantsToReportCommunity;

  const OBReportCommunityTile({
    Key? key,
    this.onCommunityReported,
    required this.community,
    this.onWantsToReportCommunity,
  }) : super(key: key);

  @override
  OBReportCommunityTileState createState() {
    return OBReportCommunityTileState();
  }
}

class OBReportCommunityTileState extends State<OBReportCommunityTile> {
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
      stream: widget.community.updateSubject,
      initialData: widget.community,
      builder: (BuildContext context, AsyncSnapshot<Community> snapshot) {
        var community = snapshot.data;

        bool isReported = community?.isReported ?? false;

        return OBLoadingTile(
          isLoading: _requestInProgress || isReported,
          leading: OBIcon(OBIcons.report),
          title: OBText(isReported
              ? localizationService.moderation__you_have_reported_community_text
              : localizationService.moderation__report_community_text),
          onTap: isReported ? () {} : _reportCommunity,
        );
      },
    );
  }

  void _reportCommunity() {
    if (widget.onWantsToReportCommunity != null) {
      widget.onWantsToReportCommunity!();
    }
    _navigationService.navigateToReportObject(
        context: context,
        object: widget.community,
        onObjectReported: widget.onCommunityReported);
  }
}
