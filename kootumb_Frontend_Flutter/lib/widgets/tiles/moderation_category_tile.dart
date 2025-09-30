import 'package:Kootumb/models/moderation/moderation_category.dart';
import 'package:Kootumb/widgets/theming/secondary_text.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBModerationCategoryTile extends StatelessWidget {
  final ModerationCategory category;
  final Widget? trailing;
  final ValueChanged<ModerationCategory>? onPressed;
  final EdgeInsets? contentPadding;

  const OBModerationCategoryTile(
      {Key? key,
      this.trailing,
      required this.category,
      this.onPressed,
      this.contentPadding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: Key(category.id.toString()),
      onTap: () {
        if (onPressed != null) onPressed!(category);
      },
      child: ListTile(
        contentPadding: contentPadding,
        title: OBText(
          category.title!,
        ),
        subtitle: OBSecondaryText(category.description ?? ''),
        trailing: trailing,
        //trailing: OBIcon(OBIcons.chevronRight),
      ),
    );
  }
}
