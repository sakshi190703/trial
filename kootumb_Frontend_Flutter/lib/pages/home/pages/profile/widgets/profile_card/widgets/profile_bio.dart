import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/widgets/theming/actionable_smart_text.dart';
import 'package:flutter/material.dart';

class OBProfileBio extends StatelessWidget {
  final User user;

  const OBProfileBio(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: user.updateSubject,
      initialData: user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        var user = snapshot.data;
        var bio = user?.getProfileBio();

        if (bio == null) return const SizedBox();

        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Flexible(
                child: OBActionableSmartText(
                  text: bio,
                  size: OBTextSize.mediumSecondary,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
