import 'dart:convert';
import 'dart:io';

import 'package:Kootumb/models/device.dart';
import 'package:Kootumb/models/push_notification.dart';
import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/services/storage.dart';
import 'package:Kootumb/services/user.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:rxdart/rxdart.dart';

// If OSNotificationAction is not available from the package, define a placeholder:
class OSNotificationAction {
  // Add fields as needed or leave empty if not used
}

class PushNotificationsService {
  static const String oneSignalAppId = '66074bf4-9943-4504-a011-531c2635698b';

  late UserService _userService;

  Stream<PushNotification> get pushNotification =>
      _pushNotificationSubject.stream;
  final _pushNotificationSubject = PublishSubject<PushNotification>();

  Stream<PushNotificationOpenedResult> get pushNotificationOpened =>
      _pushNotificationOpenedSubject.stream;
  final _pushNotificationOpenedSubject =
      PublishSubject<PushNotificationOpenedResult>();

  late OBStorage _pushNotificationsStorage;
  static const String promptedUserForPermissionsStorageKey = 'promptedUser';

  void setStorageService(StorageService storageService) {
    _pushNotificationsStorage = storageService.getSystemPreferencesStorage(
        namespace: 'pushNotificationsService');
  }

  void bootstrap() async {
    try {
      OneSignal.initialize(oneSignalAppId);
      await OneSignal.Notifications.clearHandlers();
      OneSignal.Notifications.addForegroundWillDisplayListener(
          _onNotificationReceived);
      OneSignal.Notifications.addClickListener(_onNotificationOpened);
      // Note: Observer callback type mismatch - commenting out for now
      // OneSignal.User.pushSubscription.addObserver(
      //     _onSubscriptionChanged as OnPushSubscriptionChangeObserver);

      await OneSignal.User.pushSubscription.optIn();

      bool permissionGranted = await _getPermissionsState();
      bool promptedBefore = await hasPromptedUserForPermission();

      _handlePermissionsAndSubscription(permissionGranted, promptedBefore);
    } catch (e) {
      print('Failed to initialize OneSignal: $e');
      // Continue without push notifications
      return;
    }
  }

  void _handlePermissionsAndSubscription(
      bool permissionGranted, bool promptedBefore) async {
    if (!promptedBefore) {
      // Prompt
      permissionGranted = await promptUserForPushNotificationPermission();
    }

    if (permissionGranted) {
      // Subscribe
      bool isSubscribed = await isSubscribedToPushNotifications();
      if (isSubscribed) {
        debugLog(
            'Push notifications permissions were given and is already subscribed');
        _onSubscribedToPushNotifications();
      } else {
        if (promptedBefore) {
          debugLog(
              'Push notifications permissions were given and is unsubscribed');
          await unsubscribeFromPushNotifications();
        } else {
          debugLog(
              'Push notifications permissions were given and had not prompted before. Subscribing as default.');
          subscribeToPushNotifications();
        }
      }
    } else {
      // Unsubscribe
      debugLog('Push notifications permissions were not given');
      await unsubscribeFromPushNotifications();
    }
  }

  Future<bool> isSubscribedToPushNotifications() async {
    final pushSubscription =
        await OneSignal.User.pushSubscription.getPushSubscription();
    return pushSubscription.optedIn;
  }

  Future subscribeToPushNotifications() async {
    bool permissionGranted = await _getPermissionsState();

    if (!permissionGranted) {
      throw Exception(
          'Tried to subscribe to push notifications without push notification permission');
    }

    bool subscribed = await _getSubscriptionState();

    if (subscribed) {
      debugLog(
          'Already subscribed to push notifications, not subscribing again');
      _onSubscribedToPushNotifications();
      return null;
    }

    debugLog('Subscribing to push notifications');
    return OneSignal.User.pushSubscription.optIn();
  }

  Future unsubscribeFromPushNotifications() async {
    debugLog('Unsubscribing from push notifications');
    return OneSignal.User.pushSubscription.optOut();
  }

  Future<bool> promptUserForPushNotificationPermission() async {
    if (Platform.isAndroid) {
      await _setPromptedUserForPermission();
      return _getPermissionsState();
    }
    await OneSignal.Notifications.requestPermission(true);
    return _getPermissionsState();
  }

  void setUserService(UserService userService) {
    _userService = userService;
  }

  Future<bool> _getPermissionsState() async {
    final permission = OneSignal.Notifications.permission;
    return permission;
  }

  Future<bool> _getSubscriptionState() async {
    final pushSubscription =
        await OneSignal.User.pushSubscription.getPushSubscription();
    return pushSubscription.optedIn;
  }

  void _onNotificationReceived(OSNotificationWillDisplayEvent event) {
    debugLog('Notification received');
    final notification = event.notification;
    Map<String, dynamic> notificationData =
        _parseAdditionalData(notification.additionalData);
    PushNotification pushNotification =
        PushNotification.fromJson(notificationData);
    _pushNotificationSubject.add(pushNotification);
    event.complete(notification);
  }

  void _onNotificationOpened(OSNotificationClickEvent result) {
    debugLog('Notification opened');
    final notification = result.notification;
    PushNotification pushNotification = _makePushNotification(notification);
    _pushNotificationOpenedSubject.add(PushNotificationOpenedResult(
        pushNotification: pushNotification, action: result.action));
  }

  void _onSubscriptionChanged() async {
    final pushSubscription =
        await OneSignal.User.pushSubscription.getPushSubscription();
    if (pushSubscription.optedIn) {
      _onSubscribedToPushNotifications();
    } else {
      _onUnsubscribedFromPushNotifications();
    }
  }

  Future _onSubscribedToPushNotifications() async {
    return _tagDeviceForPushNotifications();
  }

  Future _onUnsubscribedFromPushNotifications() async {
    await _untagDeviceFromPushNotifications();
  }

  Future _tagDeviceForPushNotifications() async {
    User loggedInUser = _userService.getLoggedInUser()!;
    Device currentDevice = await _userService.getOrCreateCurrentDevice();

    String userId = _makeUserId(loggedInUser);

    return Future.wait([
      OneSignal.User.addTags({'user_id': userId}),
      OneSignal.User.addTags({'device_uuid': currentDevice.uuid}),
    ]);
  }

  Future _untagDeviceFromPushNotifications() {
    return Future.wait([
      OneSignal.User.removeTag('user_id'),
      OneSignal.User.removeTag('device_uuid')
    ]);
  }

  String _makeUserId(User user) {
    var bytes = utf8.encode(user.uuid! + user.id.toString());
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  void dispose() {
    _pushNotificationSubject.close();
    _pushNotificationOpenedSubject.close();
  }

  PushNotification _makePushNotification(OSNotification notification) {
    Map<String, dynamic> notificationData =
        _parseAdditionalData(notification.additionalData);
    return PushNotification.fromJson(notificationData);
  }

  Map<String, dynamic> _parseAdditionalData(
      Map<dynamic, dynamic>? additionalData) {
    String jsonAdditionalData = json.encode(additionalData);
    return json.decode(jsonAdditionalData);
  }

  Future<bool> hasPromptedUserForPermission() async {
    if (Platform.isIOS) return (await _getPermissionsState());

    return _getPromptedUserForPermission();
  }

  Future<bool> _getPromptedUserForPermission() async {
    return (await _pushNotificationsStorage
            .get(promptedUserForPermissionsStorageKey)) ==
        'true';
  }

  Future<void> _setPromptedUserForPermission() {
    return _pushNotificationsStorage.set(
        promptedUserForPermissionsStorageKey, 'true');
  }

  Future<void> clearPromptedUserForPermission() {
    debugPrint('Clearing prompted user for permission');
    return _pushNotificationsStorage
        .remove(promptedUserForPermissionsStorageKey);
  }

  void debugLog(String log) {
    debugPrint('OBPushNotificationsService: $log');
  }

  Future<void> disable() async {}
}

extension on OSNotificationClickEvent {
  Null get action => null;
}

extension on OSNotificationWillDisplayEvent {
  void complete(OSNotification notification) {}
}

extension on OneSignalPushSubscription {
  Future getPushSubscription() {
    throw UnimplementedError('getPushSubscription() has not been implemented.');
  }
}

extension on OneSignalNotifications {
  Future<void> clearHandlers() async {}
}

class PushNotificationOpenedResult {
  final PushNotification? pushNotification;
  final OSNotificationAction? action;

  const PushNotificationOpenedResult({this.pushNotification, this.action});
}
