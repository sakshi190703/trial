import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/widgets/cover.dart';
import 'package:flutter/cupertino.dart';

class OBProfileCover extends StatelessWidget {
  final User? user;

  const OBProfileCover(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: user?.updateSubject,
      initialData: user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        String? profileCover = user?.getProfileCover();

        return OBCover(
          coverUrl: profileCover,
        );
      },
    );
  }
}
