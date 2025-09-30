import 'package:Kootumb/pages/home/bottom_sheets/rounded_bottom_sheet.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/user_preferences.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBVideosAutoPlaySettingPickerBottomSheet extends StatefulWidget {
  final ValueChanged<VideosAutoPlaySetting> onTypeChanged;

  final VideosAutoPlaySetting? initialValue;

  const OBVideosAutoPlaySettingPickerBottomSheet(
      {Key? key, required this.onTypeChanged, this.initialValue})
      : super(key: key);

  @override
  OBVideosAutoPlaySettingPickerBottomSheetState createState() {
    return OBVideosAutoPlaySettingPickerBottomSheetState();
  }
}

class OBVideosAutoPlaySettingPickerBottomSheetState
    extends State<OBVideosAutoPlaySettingPickerBottomSheet> {
  late FixedExtentScrollController _cupertinoPickerController;
  late List<VideosAutoPlaySetting> allVideosAutoPlaySettings;

  @override
  void initState() {
    super.initState();
    allVideosAutoPlaySettings = VideosAutoPlaySetting.values();
    _cupertinoPickerController = FixedExtentScrollController(
        initialItem: widget.initialValue != null
            ? allVideosAutoPlaySettings.indexOf(widget.initialValue!)
            : 0);
  }

  @override
  Widget build(BuildContext context) {
    var kongoProvider = KongoProvider.of(context);

    Map<VideosAutoPlaySetting, String> localizationMap = kongoProvider
        .userPreferencesService
        .getVideosAutoPlaySettingLocalizationMap();

    return OBRoundedBottomSheet(
      child: SizedBox(
        height: 216,
        child: CupertinoPicker(
          scrollController: _cupertinoPickerController,
          backgroundColor: Colors.transparent,
          onSelectedItemChanged: (int index) {
            VideosAutoPlaySetting newType = allVideosAutoPlaySettings[index];
            widget.onTypeChanged(newType);
          },
          itemExtent: 32,
          children:
              allVideosAutoPlaySettings.map((VideosAutoPlaySetting setting) {
            return OBText(localizationMap[setting]!);
          }).toList(),
        ),
      ),
    );
  }
}
