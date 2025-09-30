import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/navigation_service.dart';
import 'package:Kootumb/widgets/avatars/avatar.dart';
import 'package:Kootumb/widgets/theming/secondary_text.dart';
import 'package:flutter/material.dart';

class OBModeratedObjectLogActor extends StatelessWidget {
  final User actor;

  const OBModeratedObjectLogActor({Key? key, required this.actor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    KongoProviderState kongoProvider = KongoProvider.of(context);
    NavigationService navigationService = kongoProvider.navigationService;

    return GestureDetector(
      onTap: () {
        navigationService.navigateToUserProfile(user: actor, context: context);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: <Widget>[
            OBAvatar(
              borderRadius: 4,
              customSize: 16,
              avatarUrl: actor.getProfileAvatar(),
            ),
            const SizedBox(
              width: 6,
            ),
            OBSecondaryText(
              '@${actor.username!}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
