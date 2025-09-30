import 'package:Kootumb/models/circle.dart';
import 'package:Kootumb/pages/home/pages/menu/pages/connections_circles/widgets/connections_circle_tile.dart';
import 'package:Kootumb/services/modal_service.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/icon_button.dart';
import 'package:Kootumb/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Kootumb/widgets/page_scaffold.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/toast.dart';
import 'package:Kootumb/services/user.dart';
import 'package:Kootumb/widgets/search_bar.dart';
import 'package:Kootumb/widgets/theming/primary_color_container.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBConnectionsCirclesPage extends StatefulWidget {
  const OBConnectionsCirclesPage({Key? key}) : super(key: key);

  @override
  State<OBConnectionsCirclesPage> createState() {
    return OBConnectionsCirclesPageState();
  }
}

class OBConnectionsCirclesPageState extends State<OBConnectionsCirclesPage> {
  late UserService _userService;
  late ToastService _toastService;
  late ModalService _modalService;

  late GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;
  late ScrollController _connectionsCirclesScrollController;
  List<Circle> _connectionsCircles = [];
  List<Circle> _connectionsCirclesSearchResults = [];

  String? _searchQuery;

  late bool _needsBootstrap;

  @override
  void initState() {
    super.initState();
    _connectionsCirclesScrollController = ScrollController();
    _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    _needsBootstrap = true;
    _connectionsCircles = [];
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var provider = KongoProvider.of(context);
      _userService = provider.userService;
      _toastService = provider.toastService;
      _modalService = provider.modalService;
      _bootstrap();
      _needsBootstrap = false;
    }

    var loggedInUser = _userService.getLoggedInUser();

    return OBCupertinoPageScaffold(
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        navigationBar: OBThemedNavigationBar(
          title: 'My circles',
          leading: OBIconButton(
            OBIcons.close,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          trailing: OBIconButton(
            OBIcons.add,
            themeColor: OBIconThemeColor.primaryAccent,
            onPressed: _onWantsToCreateCircle,
          ),
        ),
        child: Stack(
          children: <Widget>[
            OBPrimaryColorContainer(
              child: Column(
                children: <Widget>[
                  SizedBox(
                      child: OBSearchBar(
                    onSearch: _onSearch,
                    hintText: 'Search for a circle...',
                  )),
                  Expanded(
                    child: RefreshIndicator(
                        key: _refreshIndicatorKey,
                        onRefresh: _refreshComments,
                        child: ListView.builder(
                            controller: _connectionsCirclesScrollController,
                            padding: EdgeInsets.all(0),
                            itemCount:
                                _connectionsCirclesSearchResults.length + 1,
                            itemBuilder: (context, index) {
                              if (index ==
                                  _connectionsCirclesSearchResults.length) {
                                if (_connectionsCirclesSearchResults.isEmpty) {
                                  // Results were empty
                                  if (_searchQuery != null) {
                                    return ListTile(
                                        leading: OBIcon(OBIcons.sad),
                                        title: OBText(
                                            'No circles found for "$_searchQuery"'));
                                  } else {
                                    return ListTile(
                                        leading: OBIcon(OBIcons.sad),
                                        title: OBText('No circles found.'));
                                  }
                                } else {
                                  return const SizedBox();
                                }
                              }

                              var connectionsCircle =
                                  _connectionsCirclesSearchResults[index];

                              onConnectionsCircleDeletedCallback() {
                                _removeConnectionsCircle(connectionsCircle);
                              }

                              return OBConnectionsCircleTile(
                                connectionsCircle: connectionsCircle,
                                isReadOnly: loggedInUser?.isConnectionsCircle(
                                        connectionsCircle) ??
                                    false,
                                onConnectionsCircleDeletedCallback:
                                    onConnectionsCircleDeletedCallback,
                              );
                            })),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  void _bootstrap() async {
    await _refreshComments();
  }

  Future<void> _refreshComments() async {
    try {
      _connectionsCircles =
          (await _userService.getConnectionsCircles()).circles!;
      // This assumes the connections circle always come last
      Circle connectionsCircle = _connectionsCircles.removeLast();
      _connectionsCircles.insert(0, connectionsCircle);
      _setConnectionsCircles(_connectionsCircles);
      _scrollToTop();
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
          message: errorMessage ?? 'Unknown error', context: context);
    } else {
      _toastService.error(message: 'Unknown error', context: context);
      throw error;
    }
  }

  void _onWantsToCreateCircle() async {
    Circle? createdConnectionsCircle =
        await _modalService.openCreateConnectionsCircle(context: context);
    if (createdConnectionsCircle != null) {
      _onConnectionsCircleCreated(createdConnectionsCircle);
    }
  }

  void _onSearch(String query) {
    if (query.isEmpty) {
      _resetConnectionsCirclesSearchResults();
      _setSearchQuery(null);
      return;
    }
    _setSearchQuery(query);
    String uppercaseQuery = query.toUpperCase();
    var searchResults = _connectionsCircles.where((connectionsCircle) {
      return connectionsCircle.name!.toUpperCase().contains(uppercaseQuery);
    }).toList();

    _setConnectionsCirclesSearchResults(searchResults);
  }

  void _resetConnectionsCirclesSearchResults() {
    _setConnectionsCirclesSearchResults(_connectionsCircles.toList());
  }

  void _setConnectionsCirclesSearchResults(
      List<Circle> connectionsCirclesSearchResults) {
    setState(() {
      _connectionsCirclesSearchResults = connectionsCirclesSearchResults;
    });
  }

  void _removeConnectionsCircle(Circle connectionsCircle) {
    setState(() {
      _connectionsCircles.remove(connectionsCircle);
      _connectionsCirclesSearchResults.remove(connectionsCircle);
    });
  }

  void _onConnectionsCircleCreated(Circle createdConnectionsCircle) {
    _connectionsCircles.insert(1, createdConnectionsCircle);
    _setConnectionsCircles(_connectionsCircles.toList());
    _scrollToTop();
  }

  void _scrollToTop() {
    _connectionsCirclesScrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _setConnectionsCircles(List<Circle> connectionsCircles) {
    setState(() {
      _connectionsCircles = connectionsCircles;
      _resetConnectionsCirclesSearchResults();
    });
  }

  void _setSearchQuery(String? searchQuery) {
    setState(() {
      _searchQuery = searchQuery;
    });
  }
}

typedef OnWantsToCreateConnectionsCircle = Future<Circle> Function();
typedef OnWantsToEditConnectionsCircle = Future<Circle> Function(
    Circle connectionsCircle);
typedef OnWantsToSeeConnectionsCircle = void Function(Circle connectionsCircle);
