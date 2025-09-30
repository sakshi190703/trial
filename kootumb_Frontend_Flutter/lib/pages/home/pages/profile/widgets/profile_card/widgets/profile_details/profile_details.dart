import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/pages/home/pages/profile/widgets/profile_card/widgets/profile_details/widgets/profile_age.dart';
import 'package:Kootumb/pages/home/pages/profile/widgets/profile_card/widgets/profile_details/widgets/profile_location.dart';
import 'package:Kootumb/pages/home/pages/profile/widgets/profile_card/widgets/profile_details/widgets/profile_url.dart';
import 'package:flutter/material.dart';

class OBProfileDetails extends StatelessWidget {
  final User user;

  const OBProfileDetails(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: user.updateSubject,
      initialData: user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        var user = snapshot.data;
        if (user == null ||
            ((!user.hasProfileLocation() && !user.hasProfileUrl()) &&
                !user.hasAge())) {
          return const SizedBox();
        }

        int childrenCount = 0;

        if (user.hasProfileLocation()) childrenCount++;
        if (user.hasProfileUrl()) childrenCount++;
        if (user.hasAge()) childrenCount++;

        return Padding(
            padding: EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    child: Wrap(
                      spacing: childrenCount == 1 ? 0.0 : 10.0,
                      runSpacing: 10.0,
                      children: <Widget>[
                        OBProfileLocation(user),
                        OBProfileUrl(user),
                        OBProfileAge(user),
                      ],
                    ),
                  ),
                )
              ],
            ));
      },
    );
  }
}
