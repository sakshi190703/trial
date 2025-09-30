import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/nav_bars/themed_nav_bar.dart';
import 'package:flutter/cupertino.dart';

class OBProfileNavBar extends StatelessWidget
    implements ObstructingPreferredSizeWidget {
  final User user;

  const OBProfileNavBar(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: user.updateSubject,
        initialData: user,
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          var user = snapshot.data!;
          return OBThemedNavigationBar(
              title: '@${user.username!}',
              leading: OBIcon(
                OBIcons.close,
                size: OBIconSize.notVisi,
              ));
        });
  }

  bool get fullObstruction {
    return true;
  }

  @override
  Size get preferredSize {
    return const Size.fromHeight(44);
  }

  @override
  bool shouldFullyObstruct(BuildContext context) {
    return true;
  }
}
