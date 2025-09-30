import 'package:Kootumb/provider.dart';
import 'package:Kootumb/widgets/buttons/button.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBStreamLoadMoreButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? text;

  const OBStreamLoadMoreButton({Key? key, this.onPressed, this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    KongoProviderState kongoProvider = KongoProvider.of(context);

    String buttonText =
        text ?? kongoProvider.localizationService.post__load_more;

    return OBButton(
        type: OBButtonType.highlight,
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const OBIcon(
              OBIcons.loadMore,
              customSize: 20.0,
            ),
            const SizedBox(
              width: 10.0,
            ),
            OBText(buttonText),
          ],
        ));
  }
}
