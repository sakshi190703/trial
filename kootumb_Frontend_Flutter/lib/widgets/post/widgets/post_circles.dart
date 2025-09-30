import 'package:Kootumb/models/circle.dart';
import 'package:Kootumb/models/post.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/cirles_wrap.dart';
import 'package:Kootumb/widgets/theming/actionable_smart_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../provider.dart';

class OBPostCircles extends StatelessWidget {
  final Post _post;

  const OBPostCircles(this._post, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocalizationService localizationService =
        KongoProvider.of(context).localizationService;
    if (_post.hasCircles()) {
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: SizedBox(
          height: 26.0,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            itemCount: 1,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return OBCirclesWrap(
                  textSize: OBTextSize.small,
                  circlePreviewSize: OBCircleColorPreviewSize.extraSmall,
                  leading: OBText(
                      localizationService.trans('post__you_shared_with'),
                      size: OBTextSize.small),
                  circles: _post.getPostCircles());
            },
          ),
        ),
      );
    } else if (_post.isEncircled != null && _post.isEncircled!) {
      String postCreatorUsername = _post.creator!.username!;

      return Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
        child: Row(
          children: <Widget>[
            OBText(
              localizationService.trans('post__shared_privately_on'),
              size: OBTextSize.small,
            ),
            SizedBox(
              width: 10,
            ),
            OBCircleColorPreview(
              Circle(color: '#ffffff'),
              size: OBCircleColorPreviewSize.extraSmall,
            ),
            SizedBox(
              width: 5,
            ),
            Flexible(
              child: OBActionableSmartText(
                text: localizationService
                    .post__usernames_circles(postCreatorUsername),
                size: OBTextSize.small,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox();
  }
}
