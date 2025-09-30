import 'package:Kootumb/models/follows_list.dart';
import 'package:Kootumb/pages/home/pages/menu/pages/follows_list/widgets/follows_list_header/follows_list_header.dart';
import 'package:Kootumb/pages/home/pages/menu/pages/follows_list/widgets/follows_list_users.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/icon_button.dart';
import 'package:Kootumb/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Kootumb/widgets/page_scaffold.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/toast.dart';
import 'package:Kootumb/services/user.dart';
import 'package:Kootumb/widgets/theming/primary_accent_text.dart';
import 'package:Kootumb/widgets/theming/primary_color_container.dart';
import 'package:flutter/material.dart';

class OBFollowsListPage extends StatefulWidget {
  final FollowsList followsList;

  const OBFollowsListPage(this.followsList, {Key? key}) : super(key: key);

  @override
  State<OBFollowsListPage> createState() {
    return OBFollowsListPageState();
  }
}

class OBFollowsListPageState extends State<OBFollowsListPage> {
  late UserService _userService;
  late ToastService _toastService;
  late LocalizationService _localizationService;

  late GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;
  late bool _needsBootstrap;

  @override
  void initState() {
    super.initState();
    _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    _needsBootstrap = true;
  }

  @override
  Widget build(BuildContext context) {
    var kongoProvider = KongoProvider.of(context);
    _userService = kongoProvider.userService;
    _toastService = kongoProvider.toastService;
    _localizationService = kongoProvider.localizationService;
    var modalService = kongoProvider.modalService;

    if (_needsBootstrap) {
      _bootstrap();
      _needsBootstrap = false;
    }

    return OBCupertinoPageScaffold(
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        navigationBar: OBThemedNavigationBar(
          leading: OBIconButton(
            OBIcons.close,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          trailing: GestureDetector(
            onTap: () {
              modalService.openEditFollowsList(
                  followsList: widget.followsList, context: context);
            },
            child: OBPrimaryAccentText(
                _localizationService.user__follows_list_edit),
          ),
        ),
        child: RefreshIndicator(
            key: _refreshIndicatorKey,
            onRefresh: _refreshFollowsList,
            child: OBPrimaryColorContainer(
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    OBFollowsListHeader(widget.followsList),
                    Expanded(
                      child: OBFollowsListUsers(widget.followsList),
                    ),
                  ],
                ),
              ),
            )));
  }

  void _bootstrap() async {
    await _refreshFollowsList();
  }

  Future<void> _refreshFollowsList() async {
    try {
      await _userService.getFollowsListWithId(widget.followsList.id!);
    } catch (error) {
      _onError(error);
    }
  }

  void _onError(error) async {
    if (error is HttpieConnectionRefusedError) {
      _toastService.error(
          message: error.toHumanReadableMessage(), context: context);
    } else if (error is HttpieRequestError) {
      String? errorMessage = await error.toHumanReadableMessage();
      _toastService.error(
          message: errorMessage ?? _localizationService.error__unknown_error,
          context: context);
    } else {
      _toastService.error(
          message: _localizationService.error__unknown_error, context: context);
      throw error;
    }
  }
}
