import 'package:Kootumb/models/moderation/moderated_object.dart';
import 'package:Kootumb/models/moderation/moderated_object_log.dart';
import 'package:Kootumb/widgets/theming/secondary_text.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/material.dart';


class OBModeratedObjectStatusChangedLogTile extends StatelessWidget {
  final ModeratedObjectLog log;
  final ModeratedObjectStatusChangedLog moderatedObjectStatusChangedLog;
  final VoidCallback? onPressed;

  const OBModeratedObjectStatusChangedLogTile(
      {Key? key,
      required this.log,
      required this.moderatedObjectStatusChangedLog,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          OBText(
            'Status changed from:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          OBSecondaryText(ModeratedObject.factory
              .convertStatusToHumanReadableString(
                  moderatedObjectStatusChangedLog.changedFrom,
                  capitalize: true)!),
          const SizedBox(
            height: 10,
          ),
          OBText(
            'To:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          OBSecondaryText(ModeratedObject.factory
              .convertStatusToHumanReadableString(
                  moderatedObjectStatusChangedLog.changedTo,
                  capitalize: true)!),
        ],
      ),
    );
  }
}
