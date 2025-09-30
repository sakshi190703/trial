import 'package:Kootumb/models/circle.dart';
import 'package:Kootumb/widgets/circle_color_preview.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/material.dart';
export 'package:Kootumb/widgets/circle_color_preview.dart';

class OBCirclesWrap extends StatelessWidget {
  final List<Circle>? circles;
  final Widget? leading;
  final OBTextSize textSize;
  final OBCircleColorPreviewSize circlePreviewSize;

  const OBCirclesWrap(
      {Key? key,
      this.circles,
      this.leading,
      this.textSize = OBTextSize.medium,
      this.circlePreviewSize = OBCircleColorPreviewSize.small})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> connectionItems = [];

    if (leading != null) connectionItems.add(leading!);

    circles?.forEach((Circle circle) {
      connectionItems.add(Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          OBCircleColorPreview(
            circle,
            size: circlePreviewSize,
          ),
          const SizedBox(
            width: 5,
          ),
          OBText(
            circle.name!,
            size: textSize,
          )
        ],
      ));
    });

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: connectionItems,
    );
  }
}
