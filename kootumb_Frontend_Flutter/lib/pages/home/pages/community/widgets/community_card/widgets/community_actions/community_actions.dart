import 'package:Kootumb/models/community.dart';
import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/pages/home/pages/community/widgets/community_card/widgets/community_actions/widgets/community_action_more/community_action_more.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/services/navigation_service.dart';
import 'package:Kootumb/services/user.dart';
import 'package:Kootumb/widgets/buttons/actions/join_community_button.dart';
import 'package:Kootumb/widgets/buttons/community_button.dart';
import 'package:flutter/material.dart';

class OBCommunityActions extends StatelessWidget {
  final Community? community;

  const OBCommunityActions(this.community, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var kongoProvider = KongoProvider.of(context);
    NavigationService navigationService = kongoProvider.navigationService;
    UserService userService = kongoProvider.userService;
    LocalizationService localizationService = kongoProvider.localizationService;

    User loggedInUser = userService.getLoggedInUser()!;

    bool isCommunityAdmin = community?.isAdministrator(loggedInUser) ?? false;
    bool isCommunityModerator = community?.isModerator(loggedInUser) ?? false;

    List<Widget> actions = [];

    if (isCommunityAdmin || isCommunityModerator) {
      actions.add(
          _buildManageButton(navigationService, context, localizationService));
    } else {
      actions.addAll([
        OBJoinCommunityButton(community!),
        const SizedBox(
          width: 10,
        ),
        OBCommunityActionMore(community!)
      ]);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: actions,
    );
  }

  OBCommunityButton _buildManageButton(NavigationService navigationService,
      context, LocalizationService localizationService) {
    return OBCommunityButton(
        community: community!,
        isLoading: false,
        text: localizationService.community__actions_manage_text,
        onPressed: () {
          navigationService.navigateToManageCommunity(
              community: community!, context: context);
        });
  }
}
