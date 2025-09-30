import 'package:Kootumb/models/community.dart';
import 'package:Kootumb/pages/home/bottom_sheets/rounded_bottom_sheet.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../provider.dart';

// The sheet is stateful as there is a stupid bug that makes CupertinoPicker
// pretty much useless without the bootstrap hack
// https://github.com/flutter/flutter/issues/28109

class OBCommunityTypePickerBottomSheet extends StatefulWidget {
  final ValueChanged<CommunityType> onTypeChanged;

  // Useless for now given the bug
  final CommunityType? initialType;

  const OBCommunityTypePickerBottomSheet(
      {Key? key, required this.onTypeChanged, this.initialType})
      : super(key: key);

  @override
  OBCommunityTypePickerBottomSheetState createState() {
    return OBCommunityTypePickerBottomSheetState();
  }
}

class OBCommunityTypePickerBottomSheetState
    extends State<OBCommunityTypePickerBottomSheet> {
  late bool _needsBootstrap;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
  }

  @override
  Widget build(BuildContext context) {
    var kongoProvider = KongoProvider.of(context);
    LocalizationService localizationService = kongoProvider.localizationService;
    // Hack.
    if (_needsBootstrap) {
      Future.delayed(Duration(milliseconds: 0), () {
        widget.onTypeChanged(CommunityType.values[0]);
      });
      _needsBootstrap = false;
    }

    return OBRoundedBottomSheet(
      child: SizedBox(
        height: 216,
        child: CupertinoPicker(
          backgroundColor: Colors.transparent,
          onSelectedItemChanged: (int index) {
            CommunityType newType = CommunityType.values[index];
            widget.onTypeChanged(newType);
          },
          itemExtent: 32,
          children: <Widget>[
            OBText(localizationService.trans('community__type_public')),
            OBText(localizationService.trans('community__type_private'))
          ],
        ),
      ),
    );
  }
}
