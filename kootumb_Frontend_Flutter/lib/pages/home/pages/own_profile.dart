import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/pages/home/lib/poppable_page_controller.dart';
import 'package:Kootumb/pages/home/pages/profile/profile.dart';
import 'package:Kootumb/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBOwnProfilePage extends StatefulWidget {
  final OBOwnProfilePageController? controller;

  const OBOwnProfilePage({
    Key? key,
    this.controller,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBOwnProfilePageState();
  }
}

class OBOwnProfilePageState extends State<OBOwnProfilePage> {
  late OBProfilePageController _profilePageController;

  @override
  void initState() {
    super.initState();
    _profilePageController = OBProfilePageController();
    if (widget.controller != null) {
      widget.controller!.attach(context: context, state: this);
    }
  }

  @override
  Widget build(BuildContext context) {
    var kongoProvider = KongoProvider.of(context);
    var userService = kongoProvider.userService;

    return StreamBuilder(
      stream: userService.loggedInUserChange,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        var data = snapshot.data;
        if (data == null) return const SizedBox();
        return OBProfilePage(
          data,
          controller: _profilePageController,
        );
      },
    );
  }

  void scrollToTop() {
    _profilePageController.scrollToTop();
  }
}

class OBOwnProfilePageController extends PoppablePageController {
  OBOwnProfilePageState? _state;

  @override
  void attach({required BuildContext context, OBOwnProfilePageState? state}) {
    super.attach(context: context);
    _state = state;
  }

  void scrollToTop() {
    if (_state != null) _state!.scrollToTop();
  }
}
