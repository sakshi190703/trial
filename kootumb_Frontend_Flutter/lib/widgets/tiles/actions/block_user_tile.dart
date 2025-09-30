
import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBBlockUserTile extends StatelessWidget {
  final User user;
  final VoidCallback? onBlockedUser;
  final VoidCallback? onUnblockedUser;

  const OBBlockUserTile({
    Key? key,
    required this.user,
    this.onBlockedUser,
    this.onUnblockedUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var kongoProvider = KongoProvider.of(context);
    var userService = kongoProvider.userService;
    var toastService = kongoProvider.toastService;
    var localizationService = kongoProvider.localizationService;
    var bottomSheetService = kongoProvider.bottomSheetService;

    return StreamBuilder(
      stream: user.updateSubject,
      initialData: user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        var user = snapshot.data!;

        bool isBlocked = user.isBlocked ?? false;
        return ListTile(
          leading: OBIcon(isBlocked ? OBIcons.block : OBIcons.block),
          title: OBText(isBlocked
              ? localizationService.user__unblock_user
              : localizationService.user__block_user),
          onTap: isBlocked
              ? () {
                  bottomSheetService.showConfirmAction(
                      context: context,
                      subtitle: localizationService.user__unblock_description,
                      actionCompleter: (BuildContext context) async {
                        await userService.unblockUser(user);
                        toastService.success(
                            message: localizationService
                                .user__profile_action_user_unblocked,
                            context: context);
                        if (onUnblockedUser != null) onUnblockedUser!();
                      });
                }
              : () {
                  bottomSheetService.showConfirmAction(
                      context: context,
                      subtitle: localizationService.user__block_description,
                      actionCompleter: (BuildContext context) async {
                        await userService.blockUser(user);
                        toastService.success(
                            message: localizationService
                                .user__profile_action_user_blocked,
                            context: context);
                        if (onBlockedUser != null) onBlockedUser!();
                      });
                },
        );
      },
    );
  }
}
