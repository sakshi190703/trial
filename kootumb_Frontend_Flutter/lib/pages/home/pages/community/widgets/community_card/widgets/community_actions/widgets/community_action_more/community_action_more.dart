import 'package:Kootumb/models/community.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:flutter/material.dart';

class OBCommunityActionMore extends StatelessWidget {
  final Community community;

  const OBCommunityActionMore(this.community, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const OBIcon(
        OBIcons.moreVertical,
        customSize: 30,
      ),
      onPressed: () {
        KongoProviderState kongoProvider = KongoProvider.of(context);
        kongoProvider.bottomSheetService
            .showCommunityActions(context: context, community: community);
      },
    );
  }
}
