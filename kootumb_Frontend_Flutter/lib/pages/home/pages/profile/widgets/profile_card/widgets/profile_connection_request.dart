import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/widgets/alerts/alert.dart';
import 'package:Kootumb/widgets/buttons/actions/confirm_connection_button.dart';
import 'package:Kootumb/widgets/buttons/actions/deny_connection_button.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBProfileConnectionRequest extends StatelessWidget {
  final User user;

  const OBProfileConnectionRequest(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    KongoProviderState kongoProvider = KongoProvider.of(context);

    return StreamBuilder(
      stream: user.updateSubject,
      initialData: user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        var user = snapshot.data;
        var isPendingConnectionConfirmation =
            user?.isPendingConnectionConfirmation;

        if (isPendingConnectionConfirmation == null ||
            !isPendingConnectionConfirmation) {
          return const SizedBox();
        }

        String userName = user!.getProfileName()!;

        return Column(
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            OBAlert(
              child: Column(
                children: <Widget>[
                  OBText(
                    kongoProvider.localizationService
                        .user__profile_user_sent_connection_request(userName),
                    maxLines: 4,
                    size: OBTextSize.medium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      OBDenyConnectionButton(user),
                      const SizedBox(
                        width: 20,
                      ),
                      OBConfirmConnectionButton(user)
                    ],
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
