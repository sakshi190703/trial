import 'package:Kootumb/pages/home/bottom_sheets/rounded_bottom_sheet.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/user_preferences.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBLinkPreviewsSettingPickerBottomSheet extends StatefulWidget {
  final ValueChanged<LinkPreviewsSetting> onTypeChanged;

  final LinkPreviewsSetting? initialValue;

  const OBLinkPreviewsSettingPickerBottomSheet(
      {Key? key, required this.onTypeChanged, this.initialValue})
      : super(key: key);

  @override
  OBLinkPreviewsSettingPickerBottomSheetState createState() {
    return OBLinkPreviewsSettingPickerBottomSheetState();
  }
}

class OBLinkPreviewsSettingPickerBottomSheetState
    extends State<OBLinkPreviewsSettingPickerBottomSheet> {
  late FixedExtentScrollController _cupertinoPickerController;
  late List<LinkPreviewsSetting> allLinkPreviewsSettings;

  @override
  void initState() {
    super.initState();
    allLinkPreviewsSettings = LinkPreviewsSetting.values();
    _cupertinoPickerController = FixedExtentScrollController(
        initialItem: widget.initialValue != null
            ? allLinkPreviewsSettings.indexOf(widget.initialValue!)
            : 0);
  }

  @override
  Widget build(BuildContext context) {
    var kongoProvider = KongoProvider.of(context);

    Map<LinkPreviewsSetting, String> localizationMap = kongoProvider
        .userPreferencesService
        .getLinkPreviewsSettingLocalizationMap();

    return OBRoundedBottomSheet(
      child: SizedBox(
        height: 216,
        child: CupertinoPicker(
          scrollController: _cupertinoPickerController,
          backgroundColor: Colors.transparent,
          onSelectedItemChanged: (int index) {
            LinkPreviewsSetting newType = allLinkPreviewsSettings[index];
            widget.onTypeChanged(newType);
          },
          itemExtent: 32,
          children: allLinkPreviewsSettings.map((LinkPreviewsSetting setting) {
            return OBText(localizationMap[setting]!);
          }).toList(),
        ),
      ),
    );
  }
}
