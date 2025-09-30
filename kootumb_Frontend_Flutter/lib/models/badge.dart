class Badge {
  final BadgeKeyword? keyword;
  final String? keywordDescription;

  Badge({
    this.keyword,
    this.keywordDescription,
  });

  factory Badge.fromJson(Map<String, dynamic> parsedJson) {
    return Badge(
        keyword: BadgeKeyword.parse(parsedJson['keyword']),
        keywordDescription: parsedJson['keyword_description']);
  }

  Map<String, dynamic> toJson() {
    return {
      'keyword': keyword.toString(),
      'keyword_description': keywordDescription
    };
  }

  BadgeKeyword? getKeyword() {
    return keyword;
  }

  String? getKeywordDescription() {
    return keywordDescription;
  }
}

class BadgeKeyword {
  // Using a custom-built enum class to link the notification type strings
  // directly to the matching enum constants.
  // This class can still be used in switch statements as a normal enum.
  final String code;

  const BadgeKeyword._internal(this.code);

  @override
  toString() => code;

  static const angel = BadgeKeyword._internal('ANGEL');
  static const verified = BadgeKeyword._internal('VERIFIED');
  static const founder = BadgeKeyword._internal('FOUNDER');
  static const golden_founder = BadgeKeyword._internal('GOLDEN_FOUNDER');
  static const diamond_founder = BadgeKeyword._internal('DIAMOND_FOUNDER');
  static const super_founder = BadgeKeyword._internal('SUPER_FOUNDER');

  static const _values = <BadgeKeyword>[
    angel,
    verified,
    founder,
    golden_founder,
    diamond_founder,
    super_founder
  ];

  static List<BadgeKeyword> values() => _values;

  static BadgeKeyword? parse(String? string) {
    if (string == null) return null;

    BadgeKeyword? badgeKeyword;

    for (var keyword in _values) {
      if (string == keyword.code) {
        badgeKeyword = keyword;
        break;
      }
    }

    if (badgeKeyword == null) {
      print('Unsupported badge keyword');
    }

    return badgeKeyword;
  }
}
