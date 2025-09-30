import 'package:Kootumb/models/community.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/bottom_sheet.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/theming/divider.dart';
import 'package:Kootumb/widgets/theming/primary_accent_text.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBCommunityTypeField extends StatelessWidget {
  final CommunityType value;
  final ValueChanged<CommunityType>? onChanged;
  final String title;
  final String? hintText;

  const OBCommunityTypeField(
      {Key? key,
      required this.value,
      this.onChanged,
      required this.title,
      this.hintText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    BottomSheetService bottomSheetService =
        KongoProvider.of(context).bottomSheetService;
    LocalizationService localizationService =
        KongoProvider.of(context).localizationService;

    Widget typeIcon;
    String typeName;

    switch (value) {
      case CommunityType.public:
        typeIcon = OBIcon(
          OBIcons.publicCommunity,
          themeColor: OBIconThemeColor.primaryAccent,
        );
        typeName = localizationService.community__type_public;
        break;
      case CommunityType.private:
        typeIcon = OBIcon(OBIcons.privateCommunity,
            themeColor: OBIconThemeColor.primaryAccent);
        typeName = localizationService.community__type_private;
        break;
    }

    return MergeSemantics(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  OBText(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )
                ],
              ),
              subtitle: hintText != null ? OBText(hintText!) : null,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  OBPrimaryAccentText(
                    typeName,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  typeIcon,
                ],
              ),
              onTap: () {
                bottomSheetService.showCommunityTypePicker(
                    initialType: value, context: context, onChanged: onChanged);
              }),
          value == CommunityType.private
              ? Padding(
                  padding: EdgeInsetsDirectional.only(start: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      OBText(localizationService
                          .community__community_type_private_community_hint_text)
                    ],
                  ),
                )
              : const SizedBox(),
          OBDivider()
        ],
      ),
    );
  }
}
