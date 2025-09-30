import 'package:Kootumb/libs/pretty_count.dart';
import 'package:Kootumb/models/theme.dart';
import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:flutter/material.dart';

class OBProfileFollowersCount extends StatelessWidget {
  final User user;

  const OBProfileFollowersCount(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int? followersCount = user.followersCount;

    if (followersCount == 0 ||
        user.getProfileFollowersCountVisible() == false) {
      return const SizedBox();
    }

    var kongoProvider = KongoProvider.of(context);
    var themeService = kongoProvider.themeService;
    var themeValueParserService = kongoProvider.themeValueParserService;
    var userService = kongoProvider.userService;
    var navigationService = kongoProvider.navigationService;
    LocalizationService localizationService = kongoProvider.localizationService;
    String count = getPrettyCount(followersCount!, localizationService);

    return StreamBuilder(
      stream: themeService.themeChange,
      initialData: themeService.getActiveTheme(),
      builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
        var theme = snapshot.data;

        return GestureDetector(
          onTap: () {
            if (userService.isLoggedInUser(user)) {
              navigationService.navigateToFollowersPage(context: context);
            }
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: count,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: themeValueParserService.parseColor(
                            theme!.primaryTextColor,
                          ),
                        ),
                      ),
                      TextSpan(
                        text: followersCount == 1
                            ? localizationService.post__profile_counts_follower
                            : localizationService
                                .post__profile_counts_followers,
                        style: TextStyle(
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
