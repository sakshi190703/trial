import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/widgets/emoji_preview.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBProfileInLists extends StatelessWidget {
  final User user;

  const OBProfileInLists(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: user.updateSubject,
      initialData: user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        var user = snapshot.data!;
        if (!user.hasFollowLists()) return const SizedBox();
        var followsLists = user.followLists?.lists ?? [];

        List<Widget> connectionItems = [
          const OBText(
            'In lists',
          )
        ];

        for (var followsList in followsLists) {
          connectionItems.add(Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              OBEmojiPreview(
                followsList.emoji!,
                size: OBEmojiPreviewSize.small,
              ),
              const SizedBox(
                width: 5,
              ),
              OBText(
                followsList.name!,
              )
            ],
          ));
        }

        return Padding(
          padding: EdgeInsets.only(top: 20),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: connectionItems,
          ),
        );
      },
    );
  }
}
