import 'package:Kootumb/models/hashtag.dart';
import 'package:Kootumb/pages/home/bottom_sheets/rounded_bottom_sheet.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/widgets/tiles/actions/report_hashtag_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBHashtagActionsBottomSheet extends StatelessWidget {
  final Hashtag hashtag;
  final ValueChanged<Hashtag>? onHashtagReported;

  const OBHashtagActionsBottomSheet({
    Key? key,
    required this.hashtag,
    this.onHashtagReported,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> hashtagActions = [];

    hashtagActions.add(OBReportHashtagTile(
      hashtag: hashtag,
      onHashtagReported: onHashtagReported,
      onWantsToReportHashtag: () {
        KongoProviderState kongoProvider = KongoProvider.of(context);
        kongoProvider.bottomSheetService
            .dismissActiveBottomSheet(context: context);
      },
    ));

    return OBRoundedBottomSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: hashtagActions,
      ),
    );
  }
}

typedef OnHashtagDeleted = Function(Hashtag hashtag);
