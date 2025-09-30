import 'package:Kootumb/models/community.dart';
import 'package:Kootumb/widgets/cover.dart';
import 'package:flutter/cupertino.dart';

class OBCommunityCover extends StatelessWidget {
  final Community community;

  const OBCommunityCover(this.community, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: community.updateSubject,
      initialData: community,
      builder: (BuildContext context, AsyncSnapshot<Community> snapshot) {
        var community = snapshot.data;
        String? communityCover = community?.cover;

        return OBCover(
          coverUrl: communityCover,
        );
      },
    );
  }
}
