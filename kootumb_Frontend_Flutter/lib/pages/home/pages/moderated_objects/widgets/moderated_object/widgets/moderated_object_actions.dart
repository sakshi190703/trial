import 'package:Kootumb/models/community.dart';
import 'package:Kootumb/models/moderation/moderated_object.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/buttons/button.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBModeratedObjectActions extends StatelessWidget {
  final Community? community;
  final ModeratedObject moderatedObject;

  const OBModeratedObjectActions(
      {Key? key, required this.community, required this.moderatedObject})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocalizationService localizationService =
        KongoProvider.of(context).localizationService;
    List<Widget> moderatedObjectActions = [
      Expanded(
          child: OBButton(
              type: OBButtonType.highlight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const OBIcon(
                    OBIcons.reviewModeratedObject,
                    customSize: 20.0,
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  OBText(
                      localizationService.trans('moderation__actions_review')),
                ],
              ),
              onPressed: () {
                KongoProviderState kongoProvider = KongoProvider.of(context);
                if (community != null) {
                  kongoProvider.navigationService
                      .navigateToModeratedObjectCommunityReview(
                          moderatedObject: moderatedObject,
                          community: community,
                          context: context);
                } else {
                  kongoProvider.navigationService
                      .navigateToModeratedObjectGlobalReview(
                          moderatedObject: moderatedObject, context: context);
                }
              })),
    ];

    return Padding(
        padding: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              children: moderatedObjectActions,
            )
          ],
        ));
  }
}
