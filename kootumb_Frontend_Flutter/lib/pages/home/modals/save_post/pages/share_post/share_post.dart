import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/services/navigation_service.dart';
import 'package:Kootumb/services/user.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/icon_button.dart';
import 'package:Kootumb/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Kootumb/widgets/page_scaffold.dart';
import 'package:Kootumb/widgets/new_post_data_uploader.dart';
import 'package:Kootumb/widgets/progress_indicator.dart';
import 'package:Kootumb/widgets/theming/primary_color_container.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBSharePostPage extends StatefulWidget {
  final OBNewPostData createPostData;

  const OBSharePostPage({Key? key, required this.createPostData})
      : super(key: key);

  @override
  OBSharePostPageState createState() {
    return OBSharePostPageState();
  }
}

class OBSharePostPageState extends State<OBSharePostPage> {
  late bool _loggedInUserRefreshInProgress;
  late bool _needsBootstrap;
  late UserService _userService;
  late NavigationService _navigationService;
  late LocalizationService _localizationService;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _loggedInUserRefreshInProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      KongoProviderState kongoProvider = KongoProvider.of(context);
      _userService = kongoProvider.userService;
      _localizationService = kongoProvider.localizationService;
      _navigationService = kongoProvider.navigationService;
      _bootstrap();
      _needsBootstrap = false;
    }

    User loggedInUser = _userService.getLoggedInUser()!;

    return OBCupertinoPageScaffold(
        navigationBar: _buildNavigationBar(),
        child: OBPrimaryColorContainer(
          child: StreamBuilder(
            initialData: loggedInUser,
            stream: loggedInUser.updateSubject,
            builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
              User latestUser = snapshot.data!;

              if (_loggedInUserRefreshInProgress) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: OBProgressIndicator(),
                  ),
                );
              }

              const TextStyle shareToTilesSubtitleStyle =
                  TextStyle(fontSize: 14);

              List<Widget> shareToTiles = [
                ListTile(
                  leading: const OBIcon(OBIcons.circles),
                  title: OBText(_localizationService.trans('post__my_circles')),
                  subtitle: OBText(
                    _localizationService.trans('post__my_circles_desc'),
                    style: shareToTilesSubtitleStyle,
                  ),
                  onTap: _onWantsToSharePostToCircles,
                )
              ];

              if (latestUser.isMemberOfCommunities ?? false) {
                shareToTiles.add(ListTile(
                  leading: const OBIcon(OBIcons.communities),
                  title: OBText(_localizationService
                      .trans('post__share_community_title')),
                  subtitle: OBText(
                    _localizationService.trans('post__share_community_desc'),
                    style: shareToTilesSubtitleStyle,
                  ),
                  onTap: _onWantsToSharePostToCommunity,
                ));
              }

              return Column(
                children: <Widget>[
                  Expanded(
                      child: ListView(
                          padding: EdgeInsets.zero, children: shareToTiles)),
                ],
              );
            },
          ),
        ));
  }

  ObstructingPreferredSizeWidget _buildNavigationBar() {
    return OBThemedNavigationBar(
      title: _localizationService.trans('post__share_to'),
      leading: OBIconButton(
        OBIcons.close,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  void _bootstrap() {
    _refreshLoggedInUser();
  }

  Future<void> _refreshLoggedInUser() async {
    User refreshedUser = await _userService.refreshUser();
    if (!(refreshedUser.isMemberOfCommunities ?? false)) {
      // Only possibility
      _onWantsToSharePostToCircles();
    }
  }

  void _onWantsToSharePostToCircles() async {
    OBNewPostData? createPostData =
        await _navigationService.navigateToSharePostWithCircles(
            context: context, createPostData: widget.createPostData);
    if (createPostData != null) Navigator.pop(context, createPostData);
  }

  void _onWantsToSharePostToCommunity() async {
    OBNewPostData? createPostData =
        await _navigationService.navigateToSharePostWithCommunity(
            context: context, createPostData: widget.createPostData);
    if (createPostData != null) Navigator.pop(context, createPostData);
  }
}
