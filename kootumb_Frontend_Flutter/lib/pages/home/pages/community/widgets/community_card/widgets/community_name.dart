import 'package:Kootumb/models/community.dart';
import 'package:Kootumb/widgets/theming/secondary_text.dart';
import 'package:flutter/material.dart';

class OBCommunityName extends StatelessWidget {
  final Community community;

  const OBCommunityName(this.community, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: community.updateSubject,
      initialData: community,
      builder: (BuildContext context, AsyncSnapshot<Community> snapshot) {
        var community = snapshot.data;
        String? communityName = community?.name;

        return OBSecondaryText(
          'c/${communityName!}',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black45),
        );
      },
    );
  }
}
