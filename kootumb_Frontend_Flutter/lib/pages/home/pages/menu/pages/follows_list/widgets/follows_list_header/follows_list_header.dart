import 'package:Kootumb/models/follows_list.dart';
import 'package:Kootumb/pages/home/pages/menu/pages/follows_list/widgets/follows_list_header/widgets/follows_list_name.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/emoji_picker/widgets/emoji_groups/widgets/emoji_group/widgets/emoji.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../provider.dart';

class OBFollowsListHeader extends StatelessWidget {
  final FollowsList followsList;

  const OBFollowsListHeader(this.followsList, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocalizationService localizationService =
        KongoProvider.of(context).localizationService;

    return StreamBuilder(
        stream: followsList.updateSubject,
        initialData: followsList,
        builder: (BuildContext context, AsyncSnapshot<FollowsList> snapshot) {
          var followsList = snapshot.data!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: OBFollowsListName(followsList),
                    ),
                    OBEmoji(
                      followsList.emoji!,
                      size: OBEmojiSize.large,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20),
                child: OBText(
                    localizationService.user__follows_list_header_title,
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
              ),
            ],
          );
        });
  }
}
