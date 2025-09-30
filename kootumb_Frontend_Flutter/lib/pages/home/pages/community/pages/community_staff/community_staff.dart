import 'package:Kootumb/models/community.dart';
import 'package:Kootumb/pages/home/pages/community/pages/community_staff/widgets/community_administrators.dart';
import 'package:Kootumb/pages/home/pages/community/pages/community_staff/widgets/community_moderators.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Kootumb/widgets/page_scaffold.dart';
import 'package:Kootumb/widgets/theming/primary_color_container.dart';
import 'package:flutter/material.dart';

import '../../../../../../provider.dart';

class OBCommunityStaffPage extends StatelessWidget {
  final Community community;

  const OBCommunityStaffPage({Key? key, required this.community})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocalizationService localizationService =
        KongoProvider.of(context).localizationService;

    return OBCupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: localizationService.community__community_staff,
      ),
      child: OBPrimaryColorContainer(
        child: StreamBuilder(
          stream: community.updateSubject,
          initialData: community,
          builder: (BuildContext context, AsyncSnapshot<Community> snapshot) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  OBCommunityAdministrators(community),
                  OBCommunityModerators(community),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
