import 'package:flutter/material.dart';

class OBPillButton extends StatelessWidget {
  final String text;
  final Widget icon;
  final Color? color;
  final Color? textColor;

  final VoidCallback onPressed;

  const OBPillButton(
      {Key? key,
      required this.text,
      required this.icon,
      required this.onPressed,
      this.color,
      this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var button = MaterialButton(
        textColor: textColor ?? Colors.white,
        color: color,
        onPressed: onPressed,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        child: Row(
          children: <Widget>[
            icon,
            const SizedBox(
              width: 10.0,
            ),
            Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ));
    return button;
  }
}
