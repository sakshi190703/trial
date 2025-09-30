import 'package:Kootumb/models/badge.dart' as bg;
import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/avatars/avatar.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:Kootumb/widgets/theming/secondary_text.dart';
import 'package:Kootumb/widgets/user_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../provider.dart';

class OBUserTile extends StatelessWidget {
  final User user;
  final OnUserTilePressed? onUserTilePressed;
  final OnUserTileDeleted? onUserTileDeleted;
  final bool showFollowing;
  final Widget? trailing;

  const OBUserTile(this.user,
      {Key? key,
      this.onUserTilePressed,
      this.onUserTileDeleted,
      this.showFollowing = false,
      this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var kongoProvider = KongoProvider.of(context);
    LocalizationService localizationService = kongoProvider.localizationService;
    Widget tile = ListTile(
      onTap: () {
        if (onUserTilePressed != null) onUserTilePressed!(user);
      },
      leading: OBAvatar(
        size: OBAvatarSize.medium,
        avatarUrl: user.getProfileAvatar(),
      ),
      trailing: trailing,
      title: Row(children: <Widget>[
        OBText(user.username ?? '',
            style: TextStyle(fontWeight: FontWeight.bold)),
        _getUserBadge(user)
      ]),
      subtitle: Row(
        children: [
          Expanded(child: OBSecondaryText(user.getProfileName() ?? '')),
          showFollowing && user.isFollowing != null && user.isFollowing!
              ? OBSecondaryText(
                  localizationService.trans('user__tile_following'))
              : const SizedBox()
        ],
      ),
    );

    if (onUserTileDeleted != null) {
      tile = Slidable(
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.25,
          children: [
            SlidableAction(
              onPressed: (context) {
                onUserTileDeleted!(user);
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: localizationService.trans('user__tile_delete'),
            ),
          ],
        ),
        child: tile,
      );
    }
    return tile;
  }

  Widget _getUserBadge(User creator) {
    if (creator.hasProfileBadges()) {
      bg.Badge badge = creator.getProfileBadges()![0];
      return OBUserBadge(badge: badge, size: OBUserBadgeSize.small);
    }
    return const SizedBox();
  }
}

typedef OnUserTilePressed = void Function(User user);
typedef OnUserTileDeleted = void Function(User user);
