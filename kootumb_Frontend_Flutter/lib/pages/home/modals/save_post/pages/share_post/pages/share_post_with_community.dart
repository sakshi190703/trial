import 'package:Kootumb/models/community.dart';
import 'package:Kootumb/models/communities_list.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/services/user.dart';
import 'package:Kootumb/widgets/buttons/button.dart';
import 'package:Kootumb/widgets/http_list.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/icon_button.dart';
import 'package:Kootumb/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Kootumb/widgets/page_scaffold.dart';
import 'package:Kootumb/widgets/new_post_data_uploader.dart';
import 'package:Kootumb/widgets/theming/primary_color_container.dart';
import 'package:Kootumb/widgets/tiles/community_selectable_tile.dart';
import 'package:flutter/cupertino.dart';

class OBSharePostWithCommunityPage extends StatefulWidget {
  final OBNewPostData createPostData;

  const OBSharePostWithCommunityPage({Key? key, required this.createPostData})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBSharePostWithCommunityPageState();
  }
}

class OBSharePostWithCommunityPageState
    extends State<OBSharePostWithCommunityPage> {
  late UserService _userService;
  late LocalizationService _localizationService;

  Community? _chosenCommunity;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var kongoProvider = KongoProvider.of(context);
    _userService = kongoProvider.userService;
    _localizationService = kongoProvider.localizationService;

    return OBCupertinoPageScaffold(
        navigationBar: _buildNavigationBar(),
        child: OBPrimaryColorContainer(
          child: _buildAvailableAudience(),
        ));
  }

  Widget _buildAvailableAudience() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
            child: OBHttpList<Community>(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          separatorBuilder: _buildCommunitySeparator,
          listItemBuilder: _buildCommunityItem,
          searchResultListItemBuilder: _buildCommunityItem,
          listRefresher: _refreshCommunities,
          listOnScrollLoader: _loadMoreCommunities,
          listSearcher: _searchCommunities,
          resourceSingularName:
              _localizationService.trans('community__community'),
          resourcePluralName:
              _localizationService.trans('community__communities'),
        ))
      ],
    );
  }

  ObstructingPreferredSizeWidget _buildNavigationBar() {
    return OBThemedNavigationBar(
      title: _localizationService.trans('post__share_to_community'),
      leading: OBIconButton(
        OBIcons.close,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      trailing: OBButton(
        size: OBButtonSize.small,
        type: OBButtonType.primary,
        isDisabled: _chosenCommunity == null,
        onPressed: createPost,
        child: Text(_localizationService.trans('post__share_community')),
      ),
    );
  }

  Widget _buildCommunityItem(BuildContext context, Community community) {
    return OBCommunitySelectableTile(
      community: community,
      onCommunityPressed: _onCommunityPressed,
      isSelected: community == _chosenCommunity,
    );
  }

  Widget _buildCommunitySeparator(BuildContext context, int index) {
    return const SizedBox(
      height: 10,
    );
  }

  Future<void> createPost() async {
    widget.createPostData.setCommunity(_chosenCommunity!);

    Navigator.pop(context, widget.createPostData);
  }

  Future<List<Community>> _refreshCommunities() async {
    CommunitiesList communities = await _userService.getJoinedCommunities();
    return communities.communities!;
  }

  Future<List<Community>> _loadMoreCommunities(
      List<Community> communitiesList) async {
    int offset = communitiesList.length;

    List<Community> moreCommunities = (await _userService.getJoinedCommunities(
      offset: offset,
    ))
        .communities!;
    return moreCommunities;
  }

  Future<List<Community>> _searchCommunities(String query) async {
    CommunitiesList results =
        await _userService.searchJoinedCommunities(query: query);

    return results.communities!;
  }

  void _onCommunityPressed(Community pressedCommunity) {
    if (pressedCommunity == _chosenCommunity) {
      _clearChosenCommunity();
    } else {
      _setChosenCommunity(pressedCommunity);
    }
  }

  void _clearChosenCommunity() {
    _setChosenCommunity(null);
  }

  void _setChosenCommunity(Community? chosenCommunity) {
    setState(() {
      _chosenCommunity = chosenCommunity;
    });
  }
}
