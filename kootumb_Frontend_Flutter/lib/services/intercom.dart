import 'dart:convert';

import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/services/user.dart';
import 'package:crypto/crypto.dart';
import 'package:intercom_flutter/intercom_flutter.dart';

class IntercomService {
  late UserService _userService;

  late String iosApiKey;
  late String androidApiKey;
  late String appId;

  void setUserService(UserService userService) {
    _userService = userService;
  }

  void bootstrap(
      {required String iosApiKey,
      required String androidApiKey,
      required String appId}) async {
    this.iosApiKey = iosApiKey;
    this.androidApiKey = androidApiKey;
    this.appId = appId;

    // Only initialize if we have valid keys
    if (appId.isNotEmpty &&
        (iosApiKey.isNotEmpty || androidApiKey.isNotEmpty)) {
      try {
        await Intercom.instance.initialize(appId,
            iosApiKey: iosApiKey, androidApiKey: androidApiKey);
      } catch (e) {
        print('Failed to initialize Intercom: $e');
        // Continue without Intercom functionality
      }
    } else {
      print('Intercom not initialized: missing API keys');
    }
  }

  Future displayMessenger() async {
    try {
      return await Intercom.instance.displayMessenger();
    } catch (e) {
      print('Failed to display Intercom messenger: $e');
    }
  }

  Future enableIntercom() async {
    try {
      await disableIntercom();
      User? loggedInUser = _userService.getLoggedInUser();
      if (loggedInUser == null) throw 'Cannot enable intercom. Not logged in.';

      assert(loggedInUser.uuid != null && loggedInUser.id != null);

      String userId = _makeUserId(loggedInUser);
      return await Intercom.instance.loginIdentifiedUser(userId: userId);
    } catch (e) {
      print('Failed to enable Intercom: $e');
    }
  }

  Future disableIntercom() async {
    try {
      return await Intercom.instance.logout();
    } catch (e) {
      print('Failed to disable Intercom: $e');
    }
  }

  String _makeUserId(User user) {
    var bytes = utf8.encode(user.uuid! + user.id.toString());
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
}
