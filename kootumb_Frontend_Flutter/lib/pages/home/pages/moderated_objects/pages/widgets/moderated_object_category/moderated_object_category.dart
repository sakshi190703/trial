import 'package:Kootumb/models/moderation/moderated_object.dart';
import 'package:Kootumb/models/moderation/moderation_category.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/tile_group_title.dart';
import 'package:Kootumb/widgets/tiles/moderation_category_tile.dart';
import 'package:flutter/material.dart';

class OBModeratedObjectCategory extends StatelessWidget {
  final bool isEditable;
  final ModeratedObject moderatedObject;
  final ValueChanged<ModerationCategory>? onCategoryChanged;

  const OBModeratedObjectCategory(
      {Key? key,
      required this.moderatedObject,
      required this.isEditable,
      this.onCategoryChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocalizationService localizationService =
        KongoProvider.of(context).localizationService;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        OBTileGroupTitle(
          title: localizationService.moderation__category_text,
        ),
        StreamBuilder(
          initialData: moderatedObject,
          stream: moderatedObject.updateSubject,
          builder:
              (BuildContext context, AsyncSnapshot<ModeratedObject> snapshot) {
            return OBModerationCategoryTile(
              category: snapshot.data!.category!,
              onPressed: (category) async {
                if (!isEditable) return;
                KongoProviderState kongoProvider = KongoProvider.of(context);
                ModerationCategory? newModerationCategory = await kongoProvider
                    .modalService
                    .openModeratedObjectUpdateCategory(
                        context: context, moderatedObject: moderatedObject);
                if (newModerationCategory != null &&
                    onCategoryChanged != null) {
                  onCategoryChanged!(newModerationCategory);
                }
              },
              trailing: isEditable
                  ? const OBIcon(
                      OBIcons.edit,
                      themeColor: OBIconThemeColor.secondaryText,
                    )
                  : null,
            );
          },
        ),
      ],
    );
  }
}
