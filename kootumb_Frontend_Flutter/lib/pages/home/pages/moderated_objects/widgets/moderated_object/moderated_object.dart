import 'package:Kootumb/models/community.dart';
import 'package:Kootumb/models/moderation/moderated_object.dart';
import 'package:Kootumb/pages/home/pages/moderated_objects/pages/widgets/moderated_object_category/moderated_object_category.dart';
import 'package:Kootumb/pages/home/pages/moderated_objects/widgets/moderated_object/widgets/moderated_object_actions.dart';
import 'package:Kootumb/pages/home/pages/moderated_objects/widgets/moderated_object/widgets/moderated_object_preview.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/theming/divider.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:Kootumb/widgets/tile_group_title.dart';
import 'package:Kootumb/widgets/tiles/moderated_object_status_tile.dart';
import 'package:flutter/material.dart';

import '../../../../../../provider.dart';

class OBModeratedObject extends StatelessWidget {
  final ModeratedObject moderatedObject;
  final Community? community;

  const OBModeratedObject(
      {Key? key, required this.moderatedObject, this.community})
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
          title: localizationService.moderation__moderated_object_title,
        ),
        OBModeratedObjectPreview(
          moderatedObject: moderatedObject,
        ),
        const SizedBox(
          height: 10,
        ),
        OBModeratedObjectCategory(
          moderatedObject: moderatedObject,
          isEditable: false,
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  OBTileGroupTitle(
                    title:
                        localizationService.moderation__moderated_object_status,
                  ),
                  OBModeratedObjectStatusTile(
                    moderatedObject: moderatedObject,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  OBTileGroupTitle(
                    title: localizationService
                        .moderation__moderated_object_reports_count,
                  ),
                  ListTile(
                      title: OBText(moderatedObject.reportsCount.toString())),
                ],
              ),
            ),
          ],
        ),
        OBTileGroupTitle(
          title: community != null
              ? localizationService
                  .moderation__moderated_object_verified_by_staff
              : localizationService.moderation__moderated_object_verified,
        ),
        StreamBuilder(
          stream: moderatedObject.updateSubject,
          initialData: moderatedObject,
          builder:
              (BuildContext context, AsyncSnapshot<ModeratedObject> snapshot) {
            return Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                children: <Widget>[
                  OBIcon(
                    moderatedObject.verified == true
                        ? OBIcons.verify
                        : OBIcons.unverify,
                    size: OBIconSize.small,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  OBText(
                    moderatedObject.verified == true
                        ? localizationService
                            .moderation__moderated_object_true_text
                        : localizationService
                            .moderation__moderated_object_false_text,
                  )
                ],
              ),
            );
          },
        ),
        OBModeratedObjectActions(
          moderatedObject: moderatedObject,
          community: community,
        ),
        const SizedBox(
          height: 10,
        ),
        const OBDivider()
      ],
    );
  }
}
