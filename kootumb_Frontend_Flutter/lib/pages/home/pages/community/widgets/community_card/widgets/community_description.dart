import 'package:Kootumb/models/community.dart';
import 'package:Kootumb/widgets/theming/actionable_smart_text.dart';
import 'package:flutter/material.dart';

class OBCommunityDescription extends StatelessWidget {
  final Community community;

  const OBCommunityDescription(this.community, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: community.updateSubject,
      initialData: community,
      builder: (BuildContext context, AsyncSnapshot<Community> snapshot) {
        var community = snapshot.data;
        var description = community?.description;

        if (description == null) return const SizedBox();

        return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: OBActionableSmartText(
              text: description,
              size: OBTextSize.mediumSecondary,
            ));
      },
    );
  }
}
