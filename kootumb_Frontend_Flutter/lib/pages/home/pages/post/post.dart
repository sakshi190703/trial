import 'package:Kootumb/models/post.dart';
import 'package:Kootumb/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Kootumb/widgets/page_scaffold.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/toast.dart';
import 'package:Kootumb/services/user.dart';
import 'package:Kootumb/widgets/post/post.dart';
import 'package:Kootumb/widgets/theming/primary_color_container.dart';
import 'package:flutter/material.dart';

class OBPostPage extends StatefulWidget {
  final Post post;

  const OBPostPage(this.post, {Key? key}) : super(key: key);

  @override
  State<OBPostPage> createState() {
    return OBPostPageState();
  }
}

class OBPostPageState extends State<OBPostPage> {
  late UserService _userService;
  late ToastService _toastService;

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
    var provider = KongoProvider.of(context);
    _userService = provider.userService;
    _toastService = provider.toastService;

    if (_needsBootstrap) {
      _bootstrap();
      _needsBootstrap = false;
    }

    return OBCupertinoPageScaffold(
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        navigationBar: OBThemedNavigationBar(
          title: 'Post',
        ),
        child: OBPrimaryColorContainer(
          child: Column(
            children: <Widget>[
              Expanded(
                child: RefreshIndicator(
                    key: _refreshIndicatorKey,
                    onRefresh: _refreshPost,
                    child: ListView(
                      padding: const EdgeInsets.all(0),
                      children: <Widget>[
                        StreamBuilder(
                            stream: widget.post.updateSubject,
                            initialData: widget.post,
                            builder: _buildPost)
                      ],
                    )),
              ),
            ],
          ),
        ));
  }

  Widget _buildPost(BuildContext context, AsyncSnapshot<Post> snapshot) {
    Post latestPost = snapshot.data!;

    return OBPost(
      latestPost,
      key: Key(latestPost.id.toString()),
      onPostDeleted: _onPostDeleted,
    );
  }

  void _onPostDeleted(Post post) {
    Navigator.pop(context);
  }

  void _bootstrap() async {
    await _refreshPost();
  }

  Future<void> _refreshPost() async {
    try {
      // This will trigger the updateSubject of the post
      await _userService.getPostWithUuid(widget.post.uuid!);
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
}
