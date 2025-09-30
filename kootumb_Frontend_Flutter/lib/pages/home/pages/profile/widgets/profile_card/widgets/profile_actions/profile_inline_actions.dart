import 'package:Kootumb/models/community.dart';
import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/pages/home/pages/profile/widgets/profile_card/widgets/profile_actions/widgets/profile_inline_action_more_button.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/services/navigation_service.dart';
import 'package:Kootumb/widgets/buttons/actions/block_button.dart';
import 'package:Kootumb/widgets/buttons/actions/follow_button.dart';
import 'package:flutter/material.dart';

class OBProfileInlineActions extends StatelessWidget {
  final User user;
  final VoidCallback? onUserProfileUpdated;
  final ValueChanged<Community>? onExcludedCommunityRemoved;
  final ValueChanged<List<Community>>? onExcludedCommunitiesAdded;

  const OBProfileInlineActions(this.user,
      {Key? key,
      required this.onUserProfileUpdated,
      this.onExcludedCommunityRemoved,
      this.onExcludedCommunitiesAdded})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var kongoProvider = KongoProvider.of(context);
    var userService = kongoProvider.userService;
    var navigationService = kongoProvider.navigationService;
    LocalizationService localizationService = kongoProvider.localizationService;

    return StreamBuilder(
      stream: user.updateSubject,
      initialData: user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        bool isLoggedInUser = userService.isLoggedInUser(user);

        List<Widget> actions = [];

        if (isLoggedInUser) {
          actions.add(Padding(
            // The margin compensates for the height of the (missing) OBProfileActionMore
            // Fixes cut-off Edit profile button, and level out layout distances
            padding: EdgeInsets.only(top: 6.5, bottom: 6.5),
            child: _buildManageButton(
                navigationService, localizationService, context),
          ));
        } else {
          bool isBlocked = user.isBlocked ?? false;
          if (isBlocked) {
            actions.add(OBBlockButton(user));
          } else {
            actions.add(
              OBFollowButton(user),
            );
          }

          actions.addAll([
            const SizedBox(
              width: 10,
            ),
            OBProfileInlineActionsMoreButton(user)
          ]);
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: actions,
        );
      },
    );
  }

  OBButton _buildManageButton(NavigationService navigationService,
      LocalizationService localizationService, context) {
    return OBButton(
        child: Text(
          localizationService.user__manage,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          navigationService.navigateToManageProfile(
              user: user,
              context: context,
              onUserProfileUpdated: onUserProfileUpdated,
              onExcludedCommunitiesAdded: onExcludedCommunitiesAdded,
              onExcludedCommunityRemoved: onExcludedCommunityRemoved);
        });
  }
}
