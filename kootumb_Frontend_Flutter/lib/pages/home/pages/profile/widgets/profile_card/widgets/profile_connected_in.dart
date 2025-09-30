import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/cirles_wrap.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/material.dart';

import '../../../../../../../provider.dart';

class OBProfileConnectedIn extends StatelessWidget {
  final User user;

  const OBProfileConnectedIn(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocalizationService localizationService =
        KongoProvider.of(context).localizationService;

    return StreamBuilder(
      stream: user.updateSubject,
      initialData: user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        var user = snapshot.data;
        var connectedCircles = user?.connectedCircles?.circles;
        bool isFullyConnected =
            user?.isFullyConnected != null && user!.isFullyConnected!;

        if (connectedCircles == null ||
            connectedCircles.isEmpty ||
            !isFullyConnected) {
          return const SizedBox();
        }

        return Padding(
            padding: EdgeInsets.only(top: 20),
            child: OBCirclesWrap(
              circles: connectedCircles,
              leading: OBText(
                localizationService.user__profile_in_circles,
              ),
            ));
      },
    );
  }
}
