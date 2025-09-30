import 'package:Kootumb/models/community.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBCommunityTitle extends StatelessWidget {
  final Community community;

  const OBCommunityTitle(this.community, {Key? key}) : super(key: key);

  String? get headline6 => null;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: community.updateSubject,
      initialData: community,
      builder: (BuildContext context, AsyncSnapshot<Community> snapshot) {
        return OBText(
          headline6!,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        );
      },
    );
  }
}
