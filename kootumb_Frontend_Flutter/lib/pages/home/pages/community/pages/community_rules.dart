import 'package:Kootumb/models/community.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Kootumb/widgets/page_scaffold.dart';
import 'package:Kootumb/widgets/theming/actionable_smart_text.dart';
import 'package:Kootumb/widgets/theming/primary_color_container.dart';
import 'package:flutter/material.dart';

import '../../../../../provider.dart';

class OBCommunityRulesPage extends StatelessWidget {
  final Community community;

  const OBCommunityRulesPage({Key? key, required this.community})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocalizationService localizationService = KongoProvider.of(
      context,
    ).localizationService;

    return OBCupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: localizationService.community__rules_title,
      ),
      child: OBPrimaryColorContainer(
        child: StreamBuilder(
          stream: community.updateSubject,
          initialData: community,
          builder: (BuildContext context, AsyncSnapshot<Community> snapshot) {
            var community = snapshot.data;

            String? communityRules = community?.rules;

            if (communityRules!.isEmpty) return const SizedBox();

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        OBIcon(OBIcons.rules, size: OBIconSize.medium),
                        const SizedBox(width: 10),
                        OBText(
                          localizationService.community__rules_text,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    OBActionableSmartText(text: community!.rules),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
