import 'package:Kootumb/models/community.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/buttons/button.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:flutter/material.dart';

class OBCommunityButtons extends StatelessWidget {
  final Community community;

  const OBCommunityButtons({Key? key, required this.community})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> communityButtons = [];
    KongoProviderState kongoProvider = KongoProvider.of(context);
    LocalizationService localizationService = kongoProvider.localizationService;
    communityButtons.add(
      OBButton(
        onPressed: () async {
          kongoProvider.navigationService.navigateToCommunityStaffPage(
              context: context, community: community);
        },
        type: OBButtonType.highlight,
        child: Row(
          children: <Widget>[
            const OBIcon(
              OBIcons.communityStaff,
              size: OBIconSize.small,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(localizationService.trans('community__button_staff'))
          ],
        ),
      ),
    );

    if (community.rules != null && community.rules!.isNotEmpty) {
      communityButtons.add(
        OBButton(
          onPressed: () async {
            kongoProvider.navigationService.navigateToCommunityRulesPage(
                context: context, community: community);
          },
          type: OBButtonType.highlight,
          child: Row(
            children: <Widget>[
              const OBIcon(
                OBIcons.rules,
                size: OBIconSize.small,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(localizationService.trans('community__button_rules'))
            ],
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 35,
        child: ListView.separated(
          itemCount: communityButtons.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, index) {
            return communityButtons[index];
          },
          separatorBuilder: (BuildContext context, index) {
            return const SizedBox(
              width: 10,
            );
          },
        ),
      ),
    );
  }
}
