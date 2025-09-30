import 'package:Kootumb/libs/pretty_count.dart';
import 'package:Kootumb/models/follows_list.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/checkbox.dart';
import 'package:Kootumb/widgets/emoji_picker/widgets/emoji_groups/widgets/emoji_group/widgets/emoji.dart';
import 'package:Kootumb/widgets/follows_lists_horizontal_list/follows_lists_horizontal_list.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/material.dart';

import '../../../provider.dart';

class OBFollowsListHorizontalListItem extends StatelessWidget {
  final bool isSelected;
  final FollowsList followsList;
  final OnFollowsListPressed? onFollowsListPressed;
  final bool wasPreviouslySelected;

  const OBFollowsListHorizontalListItem(this.followsList,
      {Key? key,
      required this.onFollowsListPressed,
      this.isSelected = false,
      this.wasPreviouslySelected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocalizationService localizationService =
        KongoProvider.of(context).localizationService;
    int usersCount = followsList.followsCount!;

    if (wasPreviouslySelected) {
      if (!isSelected) {
        usersCount = usersCount - 1;
      }
    } else if (isSelected) {
      usersCount = usersCount + 1;
    }
    String prettyUsersCount = getPrettyCount(usersCount, localizationService);

    return GestureDetector(
      onTap: () {
        if (onFollowsListPressed != null) {
          onFollowsListPressed!(followsList);
        }
      },
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 90, minWidth: 60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                OBEmoji(
                  followsList.emoji!,
                  size: OBEmojiSize.large,
                ),
                Positioned(
                  bottom: -5,
                  right: -5,
                  child: OBCheckbox(
                    value: isSelected,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            OBText(
              followsList.name!,
              maxLines: 1,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
            ),
            OBText(
              (usersCount == 1
                  ? localizationService.user__follows_lists_account
                  : localizationService
                      .user__follows_lists_accounts(prettyUsersCount)),
              maxLines: 1,
              size: OBTextSize.extraSmall,
              style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
