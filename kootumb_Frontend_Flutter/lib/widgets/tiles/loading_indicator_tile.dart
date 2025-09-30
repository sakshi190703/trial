import 'package:Kootumb/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';

class OBLoadingIndicatorTile extends StatelessWidget {
  const OBLoadingIndicatorTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      title: Center(
        child: OBProgressIndicator(),
      ),
    );
  }
}
