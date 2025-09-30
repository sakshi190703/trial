import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/explore_timeline_preferences.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/fields/toggle_field.dart';
import 'package:Kootumb/widgets/theming/secondary_text.dart';
import 'package:flutter/material.dart';

class OBExcludeJoinedCommunitiesTile extends StatelessWidget {
  const OBExcludeJoinedCommunitiesTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = KongoProvider.of(context);
    LocalizationService localizationService = provider.localizationService;
    ExploreTimelinePreferencesService exploreTimelinePreferencesService =
        provider.exploreTimelinePreferencesService;

    return FutureBuilder(
      future: exploreTimelinePreferencesService
          .getExcludeJoinedCommunitiesSetting(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.data == null) return const SizedBox();

        return StreamBuilder(
          stream: exploreTimelinePreferencesService
              .excludeJoinedCommunitiesSettingChange,
          initialData: snapshot.data,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            bool currentExcludeJoinedCommunitiesSetting = snapshot.data!;

            return OBToggleField(
              key: Key('toggleExcludeJoinedCommunities'),
              value: currentExcludeJoinedCommunitiesSetting,
              title: localizationService.community__exclude_joined_communities,
              subtitle: OBSecondaryText(localizationService
                  .community__exclude_joined_communities_desc),
              onChanged: (bool value) {
                exploreTimelinePreferencesService
                    .setExcludeJoinedCommunitiesSetting(
                        !currentExcludeJoinedCommunitiesSetting);
              },
              hasDivider: false,
            );
          },
        );
      },
    );
  }
}
