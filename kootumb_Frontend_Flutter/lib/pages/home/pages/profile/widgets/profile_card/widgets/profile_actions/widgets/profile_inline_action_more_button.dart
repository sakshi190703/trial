import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:flutter/material.dart';
import 'package:Kootumb/services/bottom_sheet.dart';

class OBProfileInlineActionsMoreButton extends StatelessWidget {
  final User user;

  const OBProfileInlineActionsMoreButton(this.user, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: user.updateSubject,
      initialData: user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        var user = snapshot.data!;

        return IconButton(
          icon: const OBIcon(
            OBIcons.moreVertical,
            customSize: 30,
          ),
          onPressed: () {
            KongoProviderState kongoProvider = KongoProvider.of(context);
            BottomSheetService bottomSheetService =
                kongoProvider.bottomSheetService;

            bottomSheetService.showUserActions(
              context: context,
              user: user,
            );
          },
        );
      },
    );
  }
}
