import 'package:Kootumb/widgets/buttons/button.dart';
import 'package:flutter/material.dart';

class OBAccentButton extends StatelessWidget {
  final Widget child;
  final Widget? icon;
  final VoidCallback onPressed;
  final bool isDisabled;
  final bool isLoading;
  final Color textColor;
  final OBButtonSize size;
  final double? minWidth;
  final EdgeInsets? padding;

  const OBAccentButton(
      {Key? key,
      required this.child,
      required this.onPressed,
      this.size = OBButtonSize.medium,
      this.textColor = Colors.white,
      this.icon,
      this.isDisabled = false,
      this.isLoading = false,
      this.padding,
      this.minWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OBButton(
      icon: icon,
      onPressed: onPressed,
      size: size,
      isDisabled: isDisabled,
      isLoading: isLoading,
      padding: padding,
      minWidth: minWidth,
      type: OBButtonType.primary,
      child: child,
    );
  }
}
