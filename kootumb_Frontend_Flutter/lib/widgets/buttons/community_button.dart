import 'package:Kootumb/models/community.dart';
import 'package:Kootumb/models/theme.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/theme.dart';
import 'package:Kootumb/services/theme_value_parser.dart';
import 'package:Kootumb/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:tinycolor2/tinycolor2.dart';

class OBCommunityButton extends StatelessWidget {
  final Community community;
  final bool isLoading;
  final String text;
  final VoidCallback onPressed;

  static const borderRadius = 30.0;

  const OBCommunityButton(
      {Key? key,
      this.isLoading = false,
      required this.community,
      required this.text,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String communityHexColor = community.color!;
    KongoProviderState kongoProviderState = KongoProvider.of(context);
    ThemeValueParserService themeValueParserService =
        kongoProviderState.themeValueParserService;
    ThemeService themeService = kongoProviderState.themeService;

    OBTheme currentTheme = themeService.getActiveTheme();
    Color currentThemePrimaryColor =
        themeValueParserService.parseColor(currentTheme.primaryColor);
    double currentThemePrimaryColorLuminance =
        currentThemePrimaryColor.computeLuminance();

    Color communityColor =
        themeValueParserService.parseColor(communityHexColor);
    Color textColor = themeValueParserService.isDarkColor(communityColor)
        ? Colors.white
        : Colors.black;
    double communityColorLuminance = communityColor.computeLuminance();

    if (communityColorLuminance > 0.9 &&
        currentThemePrimaryColorLuminance > 0.9) {
      // Is extremely white and our current theem is also extremely white, darken it
      communityColor = TinyColor(communityColor).darken(5).color;
    } else if (communityColorLuminance < 0.1) {
      // Is extremely dark and our current theme is also extremely dark, lighten it
      communityColor = TinyColor(communityColor).lighten(10).color;
    }

    return ButtonTheme(
      minWidth: 110,
      child: MaterialButton(
          elevation: 0,
          color: communityColor,
          onPressed: onPressed,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius)),
          child: isLoading
              ? _buildLoadingIndicatorWithColor(textColor)
              : Text(
                  text,
                  style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                )),
    );
  }

  Widget _buildLoadingIndicatorWithColor(Color color) {
    return OBProgressIndicator(
      color: color,
    );
  }
}
