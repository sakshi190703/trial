import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/bottom_sheet.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/services/user.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/material.dart';

import '../../user_visibility_icon.dart';

class OBUserVisibilityTile extends StatelessWidget {
  const OBUserVisibilityTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    KongoProviderState provider = KongoProvider.of(context);

    LocalizationService localizationService = provider.localizationService;
    UserService userService = provider.userService;
    BottomSheetService bottomSheetService = provider.bottomSheetService;

    Map<UserVisibility, Map<String, String>> userVisibilitiesLocalizationMap =
        userService.getUserVisibilityLocalizationMap();

    return StreamBuilder(
      stream: userService.getLoggedInUser()!.updateSubject,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.data == null) return const SizedBox();

        UserVisibility currentUserVisibility = snapshot.data!.visibility!;

        var visibilityLocalizationsMap =
            userVisibilitiesLocalizationMap[currentUserVisibility]!;

        return ListTile(
          leading: OBUserVisibilityIcon(visibility: currentUserVisibility),
          title: OBText(visibilityLocalizationsMap['title']!),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OBText(
                visibilityLocalizationsMap['description']!,
                size: OBTextSize.mediumSecondary,
              ),
              OBText(
                localizationService.application_settings__tap_to_change,
                size: OBTextSize.small,
              )
            ],
          ),
          onTap: () {
            bottomSheetService.showUserVisibilityPicker(context: context);
          },
        );
      },
    );
  }
}
