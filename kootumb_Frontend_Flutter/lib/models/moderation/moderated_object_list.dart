import 'package:Kootumb/models/moderation/moderated_object.dart';

class ModeratedObjectsList {
  final List<ModeratedObject>? moderatedObjects;

  ModeratedObjectsList({
    this.moderatedObjects,
  });

  factory ModeratedObjectsList.fromJson(List<dynamic> parsedJson) {
    List<ModeratedObject> moderatedObjects = parsedJson
        .map((moderatedObjectJson) =>
            ModeratedObject.fromJSON(moderatedObjectJson))
        .toList();

    return ModeratedObjectsList(
      moderatedObjects: moderatedObjects,
    );
  }
}
