import 'package:Kootumb/models/post.dart';
import 'package:Kootumb/models/hashtag.dart';
import 'package:Kootumb/pages/home/pages/hashtag/widgets/hashtag_nav_bar.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/user.dart';
import 'package:Kootumb/widgets/posts_stream/posts_stream.dart';
import 'package:Kootumb/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';

class OBHashtagPage extends StatefulWidget {
  final OBHashtagPageController? controller;
  final Hashtag hashtag;
  final String rawHashtagName;

  const OBHashtagPage(
      {Key? key,
      this.controller,
      required this.hashtag,
      required this.rawHashtagName})
      : super(key: key);

  @override
  OBHashtagPageState createState() {
    return OBHashtagPageState();
  }
}

class OBHashtagPageState extends State<OBHashtagPage> {
  late Hashtag _hashtag;
  late bool _needsBootstrap;
  late UserService _userService;
  late OBPostsStreamController _obPostsStreamController;

  @override
  void initState() {
    super.initState();
    _obPostsStreamController = OBPostsStreamController();
    _needsBootstrap = true;
    _hashtag = widget.hashtag;
    if (widget.controller != null) widget.controller!.attach(this);
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var kongoProvider = KongoProvider.of(context);
      _userService = kongoProvider.userService;
      _needsBootstrap = false;
    }

    return CupertinoPageScaffold(
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        navigationBar: OBHashtagNavBar(
            key: Key('navBarHeader_${_hashtag.name}'),
            hashtag: _hashtag,
            rawHashtagName: widget.rawHashtagName),
        child: OBPrimaryColorContainer(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: OBPostsStream(
                    streamIdentifier: 'hashtag_${widget.hashtag.name}',
                    controller: _obPostsStreamController,
                    secondaryRefresher: _refreshHashtag,
                    refresher: _refreshPosts,
                    onScrollLoader: _loadMorePosts),
              )
            ],
          ),
        ));
  }

  void scrollToTop() {
    _obPostsStreamController.scrollToTop();
  }

  Future<void> _refreshHashtag() async {
    var hashtag = await _userService.getHashtagWithName(_hashtag.name!);
    _setHashtag(hashtag);
  }

  Future<List<Post>> _refreshPosts() async {
    return (await _userService.getPostsForHashtag(_hashtag)).posts ?? [];
  }

  Future<List<Post>> _loadMorePosts(List<Post> posts) async {
    Post lastPost = posts.last;

    return (await _userService.getPostsForHashtag(_hashtag, maxId: lastPost.id))
            .posts ??
        [];
  }

  void _setHashtag(Hashtag hashtag) {
    setState(() {
      _hashtag = hashtag;
    });
  }
}

class OBHashtagPageController {
  OBHashtagPageState? _timelinePageState;

  void attach(OBHashtagPageState? hashtagPageState) {
    assert(hashtagPageState != null, 'Cannot attach to empty state');
    _timelinePageState = hashtagPageState;
  }

  void scrollToTop() {
    if (_timelinePageState != null) _timelinePageState!.scrollToTop();
  }
}

typedef OnWantsToEditHashtagHashtag = void Function(Hashtag hashtag);
