import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/widgets/theming/secondary_text.dart';
import 'package:flutter/material.dart';

class OBProfileUsername extends StatelessWidget {
  final User user;

  const OBProfileUsername(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: user.updateSubject,
      initialData: user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        var user = snapshot.data;
        var username = user?.username;

        if (username == null) {
          return const SizedBox(
            height: 10.0,
          );
        }

        return OBSecondaryText(
          '@$username',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black45),
        );
      },
    );
  }
}
