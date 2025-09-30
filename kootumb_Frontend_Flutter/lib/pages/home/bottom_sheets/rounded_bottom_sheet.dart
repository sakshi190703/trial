import 'package:Kootumb/widgets/theming/highlighted_color_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBRoundedBottomSheet extends StatelessWidget {
  final Widget child;

  const OBRoundedBottomSheet({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const borderRadius = Radius.circular(10);

    return OBHighlightedColorContainer(
        mainAxisSize: MainAxisSize.min,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: borderRadius, topLeft: borderRadius)),
        child: child);
  }
}
