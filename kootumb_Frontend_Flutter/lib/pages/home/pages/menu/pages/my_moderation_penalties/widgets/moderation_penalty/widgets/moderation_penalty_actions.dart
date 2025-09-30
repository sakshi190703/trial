import 'package:Kootumb/models/moderation/moderation_penalty.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/buttons/button.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBModerationPenaltyActions extends StatelessWidget {
  final ModerationPenalty moderationPenalty;

  const OBModerationPenaltyActions({Key? key, required this.moderationPenalty})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocalizationService localizationService =
        KongoProvider.of(context).localizationService;

    List<Widget> moderationPenaltyActions = [
      Expanded(
          child: OBButton(
              type: OBButtonType.highlight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const OBIcon(
                    OBIcons.chat,
                    customSize: 20.0,
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  OBText(localizationService
                      .trans('moderation__actions_chat_with_team')),
                ],
              ),
              onPressed: () {
                KongoProviderState kongoProvider = KongoProvider.of(context);
                kongoProvider.intercomService.displayMessenger();
              })),
    ];

    return Padding(
        padding: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              children: moderationPenaltyActions,
            )
          ],
        ));
  }
}
