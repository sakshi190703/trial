import 'package:Kootumb/models/follows_list.dart';
import 'package:Kootumb/widgets/theming/primary_accent_text.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:Kootumb/widgets/theming/secondary_text.dart';
import 'package:flutter/material.dart';

class OBFollowsListName extends StatelessWidget {
  final FollowsList followsList;

  const OBFollowsListName(this.followsList, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: followsList.updateSubject,
        initialData: followsList,
        builder: (BuildContext context, AsyncSnapshot<FollowsList> snapshot) {
          var followsList = snapshot.data!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              OBSecondaryText(
                'List',
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Flexible(
                    child: OBPrimaryAccentText(
                      followsList.name!,
                      size: OBTextSize.extraLarge,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          );
        });
  }
}
