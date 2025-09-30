import 'package:Kootumb/libs/pretty_count.dart';
import 'package:Kootumb/models/circle.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/tiles/circle_selectable_tile.dart';
import 'package:Kootumb/widgets/checkbox.dart';
import 'package:Kootumb/widgets/circle_color_preview.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/material.dart';

import '../../../provider.dart';

class OBCircleHorizontalListItem extends StatelessWidget {
  final bool isSelected;
  final bool isDisabled;
  final Circle circle;
  final OnCirclePressed? onCirclePressed;
  final bool wasPreviouslySelected;

  const OBCircleHorizontalListItem(this.circle,
      {Key? key,
      required this.onCirclePressed,
      this.isSelected = false,
      this.isDisabled = false,
      this.wasPreviouslySelected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int usersCount = circle.usersCount!;
    LocalizationService localizationService =
        KongoProvider.of(context).localizationService;

    if (wasPreviouslySelected) {
      if (!isSelected) {
        usersCount = usersCount - 1;
      }
    } else if (isSelected) {
      usersCount = usersCount + 1;
    }
    String prettyUsersCount = getPrettyCount(usersCount, localizationService);

    Widget item = GestureDetector(
      onTap: () {
        if (onCirclePressed != null && !isDisabled) {
          onCirclePressed!(circle);
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
                OBCircleColorPreview(
                  circle,
                  size: OBCircleColorPreviewSize.large,
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
              circle.name!,
              maxLines: 1,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
            ),
            OBText(
              '$prettyUsersCount People',
              maxLines: 1,
              size: OBTextSize.extraSmall,
              style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
            ),
          ],
        ),
      ),
    );

    if (isDisabled) {
      item = Opacity(
        opacity: 0.5,
        child: item,
      );
    }

    return item;
  }
}
