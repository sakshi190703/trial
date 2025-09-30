import 'package:Kootumb/models/post.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/theming/actionable_smart_text.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../provider.dart';

class OBPostIsClosed extends StatelessWidget {
  final Post _post;

  const OBPostIsClosed(this._post, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isClosed = _post.isClosed ?? false;
    LocalizationService localizationService =
        KongoProvider.of(context).localizationService;

    if (isClosed) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Row(
          children: <Widget>[
            const OBIcon(
              OBIcons.closePost,
              size: OBIconSize.small,
            ),
            const SizedBox(
              width: 10,
            ),
            OBText(localizationService.post__is_closed, size: OBTextSize.small)
          ],
        ),
      );
    }

    return const SizedBox();
  }
}
