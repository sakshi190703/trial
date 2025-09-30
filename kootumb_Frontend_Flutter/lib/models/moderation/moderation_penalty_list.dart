import 'package:Kootumb/models/moderation/moderation_penalty.dart';

class ModerationPenaltiesList {
  final List<ModerationPenalty>? moderationPenalties;

  ModerationPenaltiesList({
    this.moderationPenalties,
  });

  factory ModerationPenaltiesList.fromJson(List<dynamic> parsedJson) {
    List<ModerationPenalty> moderationPenalties = parsedJson
        .map((moderationPenaltyJson) =>
            ModerationPenalty.fromJson(moderationPenaltyJson))
        .toList();

    return ModerationPenaltiesList(
      moderationPenalties: moderationPenalties,
    );
  }
}
