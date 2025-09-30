import 'package:Kootumb/models/notifications/notification.dart';

class NotificationsList {
  final List<OBNotification>? notifications;

  NotificationsList({
    this.notifications,
  });

  factory NotificationsList.fromJson(List<dynamic> parsedJson) {
    List<OBNotification> notifications = parsedJson
        .map((notificationJson) => OBNotification.fromJSON(notificationJson))
        .toList();

    return NotificationsList(
      notifications: notifications,
    );
  }
}
