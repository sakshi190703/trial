import 'package:Kootumb/pages/home/bottom_sheets/rounded_bottom_sheet.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/user_preferences.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBHashtagsDisplaySettingPickerBottomSheet extends StatefulWidget {
  final ValueChanged<HashtagsDisplaySetting> onTypeChanged;

  final HashtagsDisplaySetting? initialValue;

  const OBHashtagsDisplaySettingPickerBottomSheet(
      {Key? key, required this.onTypeChanged, this.initialValue})
      : super(key: key);

  @override
  OBHashtagsDisplaySettingPickerBottomSheetState createState() {
    return OBHashtagsDisplaySettingPickerBottomSheetState();
  }
}

class OBHashtagsDisplaySettingPickerBottomSheetState
    extends State<OBHashtagsDisplaySettingPickerBottomSheet> {
  late FixedExtentScrollController _cupertinoPickerController;
  late List<HashtagsDisplaySetting> allHashtagsDisplaySettings;

  @override
  void initState() {
    super.initState();
    allHashtagsDisplaySettings = HashtagsDisplaySetting.values();
    _cupertinoPickerController = FixedExtentScrollController(
        initialItem: widget.initialValue != null
            ? allHashtagsDisplaySettings.indexOf(widget.initialValue!)
            : 0);
  }

  @override
  Widget build(BuildContext context) {
    var kongoProvider = KongoProvider.of(context);
    UserPreferencesService userPreferencesService =
        kongoProvider.userPreferencesService;

    Map<HashtagsDisplaySetting, String> localizationMap =
        userPreferencesService.getHashtagsDisplaySettingLocalizationMap();

    return OBRoundedBottomSheet(
      child: SizedBox(
        height: 216,
        child: CupertinoPicker(
          scrollController: _cupertinoPickerController,
          backgroundColor: Colors.transparent,
          onSelectedItemChanged: (int index) {
            HashtagsDisplaySetting newType = allHashtagsDisplaySettings[index];
            widget.onTypeChanged(newType);
          },
          itemExtent: 32,
          children:
              allHashtagsDisplaySettings.map((HashtagsDisplaySetting setting) {
            return Center(
              child: OBText(localizationMap[setting]!),
            );
          }).toList(),
        ),
      ),
    );
  }
}
