import 'package:Kootumb/models/community.dart';
import 'package:Kootumb/models/theme.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/services/theme.dart';
import 'package:Kootumb/services/theme_value_parser.dart';
import 'package:Kootumb/widgets/buttons/button.dart';
import 'package:Kootumb/widgets/buttons/floating_action_button.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/new_post_data_uploader.dart';
import 'package:flutter/material.dart';
import 'package:tinycolor2/tinycolor2.dart';

class OBCommunityNewPostButton extends StatelessWidget {
  final bool isDisabled;
  final bool isLoading;
  final Color textColor;
  final OBButtonSize size;
  final double? minWidth;
  final EdgeInsets? padding;
  final OBButtonType type;
  final Community community;
  final ValueChanged<OBNewPostData>? onWantsToUploadNewPostData;

  const OBCommunityNewPostButton({
    Key? key,
    this.type = OBButtonType.primary,
    this.size = OBButtonSize.medium,
    this.textColor = Colors.white,
    this.isDisabled = false,
    this.isLoading = false,
    this.padding,
    this.minWidth,
    required this.community,
    this.onWantsToUploadNewPostData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocalizationService localizationService =
        KongoProvider.of(context).localizationService;
    return StreamBuilder(
      stream: community.updateSubject,
      initialData: community,
      builder: (BuildContext context, AsyncSnapshot<Community> snapshot) {
        Community community = snapshot.data!;

        String communityHexColor = community.color!;
        KongoProviderState kongoProvider = KongoProvider.of(context);
        ThemeValueParserService themeValueParserService =
            kongoProvider.themeValueParserService;
        ThemeService themeService = kongoProvider.themeService;

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

        return Semantics(
            button: true,
            label: localizationService.post__create_new_community_post_label,
            child: OBFloatingActionButton(
                color: communityColor,
                textColor: textColor,
                onPressed: () async {
                  KongoProviderState kongoProvider = KongoProvider.of(context);
                  OBNewPostData? createPostData = await kongoProvider
                      .modalService
                      .openCreatePost(context: context, community: community);
                  if (createPostData != null &&
                      onWantsToUploadNewPostData != null) {
                    onWantsToUploadNewPostData!(createPostData);
                  }
                },
                child: OBIcon(OBIcons.createPost,
                    size: OBIconSize.large, color: textColor)));
      },
    );
  }
}
