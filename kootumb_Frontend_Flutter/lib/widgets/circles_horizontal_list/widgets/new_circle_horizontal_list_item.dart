import 'package:Kootumb/widgets/circle_color_preview.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBNewCircleHorizontalListItem extends StatelessWidget {
  final VoidCallback onPressed;

  const OBNewCircleHorizontalListItem({Key? key, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget item = GestureDetector(
      onTap: onPressed,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 90, minWidth: 60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                Container(
                  height: OBCircleColorPreview.circleSizeLarge,
                  width: OBCircleColorPreview.circleSizeLarge,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Color.fromARGB(10, 0, 0, 0), width: 3),
                      borderRadius: BorderRadius.circular(50)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: Image.asset(
                      'assets/images/theme-previews/theme-preview-colorful.png',
                    ),
                  ),
                ),
                Positioned(
                  bottom: -5,
                  right: -5,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50)),
                    child: const OBIcon(
                      OBIcons.add,
                      themeColor: OBIconThemeColor.primaryAccent,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            OBText(
              'Create new',
              style: TextStyle(fontSize: 14),
            ),
            OBText(
              'circle',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );

    return item;
  }
}
