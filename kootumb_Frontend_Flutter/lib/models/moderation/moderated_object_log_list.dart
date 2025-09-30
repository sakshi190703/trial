import 'package:Kootumb/models/moderation/moderated_object_log.dart';

class ModeratedObjectLogsList {
  final List<ModeratedObjectLog>? moderatedObjectLogs;

  ModeratedObjectLogsList({
    this.moderatedObjectLogs,
  });

  factory ModeratedObjectLogsList.fromJson(List<dynamic> parsedJson) {
    List<ModeratedObjectLog> moderatedObjectLogs = parsedJson
        .map((moderatedObjectLogJson) =>
            ModeratedObjectLog.fromJson(moderatedObjectLogJson))
        .toList();

    return ModeratedObjectLogsList(
      moderatedObjectLogs: moderatedObjectLogs,
    );
  }
}
