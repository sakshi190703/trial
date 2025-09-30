import 'package:Kootumb/widgets/alerts/button_alert.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:flutter/material.dart';

class OBNoModeratedObjects extends StatelessWidget {
  final VoidCallback onWantsToRefreshModeratedObjects;

  const OBNoModeratedObjects(
      {Key? key, required this.onWantsToRefreshModeratedObjects})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OBButtonAlert(
      text: 'No moderation items',
      onPressed: onWantsToRefreshModeratedObjects,
      buttonText: 'Refresh',
      buttonIcon: OBIcons.refresh,
      assetImage: 'assets/images/stickers/perplexed-owl.png',
    );
  }
}
