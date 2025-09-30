import 'package:Kootumb/libs/pretty_count.dart';
import 'package:Kootumb/models/theme.dart';
import 'package:Kootumb/models/community.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:flutter/material.dart';

class OBCommunityMembersCount extends StatelessWidget {
  final Community community;

  const OBCommunityMembersCount(this.community, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int? membersCount = community.membersCount;
    LocalizationService localizationService = KongoProvider.of(
      context,
    ).localizationService;

    if (membersCount == 0) return const SizedBox();

    String count = getPrettyCount(membersCount!, localizationService);

    String userAdjective = community.userAdjective ??
        localizationService.community__member_capitalized;
    String usersAdjective = community.usersAdjective ??
        localizationService.community__members_capitalized;

    var kongoProvider = KongoProvider.of(context);
    var themeService = kongoProvider.themeService;
    var themeValueParserService = kongoProvider.themeValueParserService;
    var userService = kongoProvider.userService;
    var navigationService = kongoProvider.navigationService;

    return StreamBuilder(
      stream: themeService.themeChange,
      initialData: themeService.getActiveTheme(),
      builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
        var theme = snapshot.data;

        return GestureDetector(
          onTap: () {
            bool isPublicCommunity = community.isPublic();
            bool isLoggedInUserMember = community.isMember(
              userService.getLoggedInUser()!,
            );

            if (isPublicCommunity || isLoggedInUserMember) {
              navigationService.navigateToCommunityMembers(
                community: community,
                context: context,
              );
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: count,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: themeValueParserService.parseColor(
                            theme!.primaryTextColor,
                          ),
                        ),
                      ),
                      TextSpan(text: ' '),
                      TextSpan(
                        text:
                            membersCount == 1 ? userAdjective : usersAdjective,
                        style: TextStyle(
                          fontSize: 16,
                          color: themeValueParserService.parseColor(
                            theme.secondaryTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        );
      },
    );
  }
}
