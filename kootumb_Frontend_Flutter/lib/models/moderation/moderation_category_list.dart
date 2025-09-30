import 'package:Kootumb/models/moderation/moderation_category.dart';

class ModerationCategoriesList {
  final List<ModerationCategory>? moderationCategories;

  ModerationCategoriesList({
    this.moderationCategories,
  });

  factory ModerationCategoriesList.fromJson(List<dynamic> parsedJson) {
    List<ModerationCategory> moderationCategories = parsedJson
        .map((moderationCategoryJson) =>
            ModerationCategory.fromJson(moderationCategoryJson))
        .toList();

    return ModerationCategoriesList(
      moderationCategories: moderationCategories,
    );
  }
}
