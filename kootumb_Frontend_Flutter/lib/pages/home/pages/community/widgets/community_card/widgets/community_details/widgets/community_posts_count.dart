import 'package:Kootumb/models/community.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/services/toast.dart';
import 'package:Kootumb/services/user.dart';
import 'package:Kootumb/widgets/posts_count.dart';
import 'package:Kootumb/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';

class OBCommunityPostsCount extends StatefulWidget {
  final Community community;

  const OBCommunityPostsCount(this.community, {Key? key}) : super(key: key);

  @override
  OBCommunityPostsCountState createState() {
    return OBCommunityPostsCountState();
  }
}

class OBCommunityPostsCountState extends State<OBCommunityPostsCount> {
  late UserService _userService;
  late ToastService _toastService;
  late LocalizationService _localizationService;
  late bool _requestInProgress;
  late bool _hasError;
  late bool _needsBootstrap;

  @override
  void initState() {
    super.initState();
    _requestInProgress = false;
    _hasError = false;
    _needsBootstrap = true;
  }

  @override
  Widget build(BuildContext context) {
    var kongoProvider = KongoProvider.of(context);
    _userService = kongoProvider.userService;
    if (_needsBootstrap) {
      _localizationService = kongoProvider.localizationService;
      _toastService = kongoProvider.toastService;
      _refreshCommunityPostsCount();
      _needsBootstrap = false;
    }

    return StreamBuilder(
      stream: widget.community.updateSubject,
      initialData: widget.community,
      builder: (BuildContext context, AsyncSnapshot<Community> snapshot) {
        var community = snapshot.data!;

        return _hasError
            ? _buildErrorIcon()
            : _requestInProgress
                ? _buildLoadingIcon()
                : _buildPostsCount(community);
      },
    );
  }

  Widget _buildPostsCount(Community community) {
    return OBPostsCount(
      community.postsCount,
      showZero: true,
      fontSize: 16,
    );
  }

  Widget _buildErrorIcon() {
    return const SizedBox();
  }

  Widget _buildLoadingIcon() {
    return OBProgressIndicator(
      size: 15.0,
    );
  }

  void _refreshCommunityPostsCount() async {
    _setRequestInProgress(true);
    try {
      await _userService.countPostsForCommunity(widget.community);
    } catch (e) {
      _onError(e);
    } finally {
      _setRequestInProgress(false);
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

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }
}
