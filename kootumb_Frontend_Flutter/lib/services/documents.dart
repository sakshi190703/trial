import 'package:Kootumb/services/httpie.dart';

class DocumentsService {
  late HttpieService _httpService;

  static const guidelinesUrl =
      // 'https://kootumb.github.io/kootumbPrivacy.github.io/CommunityGuidelines';
      'https://raw.githubusercontent.com/kootumb/kootumbPrivacy.github.io/refs/heads/main/CommunityGuidelines.md';
  static const privacyPolicyUrl =
      'https://kootumb.github.io/kootumbPrivacy.github.io/privacypolicy';
  static const termsOfUsePolicyUrl =
      'https://kootumb.github.io/kootumbPrivacy.github.io/kootumb%E2%80%99sTermsofuse';

  // Cache
  String _communityGuidelines = '';
  String _termsOfUse = '';
  String _privacyPolicy = '';

  void preload() {
    getCommunityGuidelines();
    getPrivacyPolicy();
    getTermsOfUse();
  }

  void setHttpService(HttpieService httpService) {
    _httpService = httpService;
  }

  Future<String> getCommunityGuidelines() async {
    if (_communityGuidelines.isNotEmpty) return _communityGuidelines;
    HttpieResponse response = await _httpService.get(guidelinesUrl);
    _communityGuidelines = response.body;
    return _communityGuidelines;
  }

  Future<String> getPrivacyPolicy() async {
    if (_privacyPolicy.isNotEmpty) return _privacyPolicy;

    HttpieResponse response = await _httpService.get(privacyPolicyUrl);
    _privacyPolicy = response.body;
    return _privacyPolicy;
  }

  Future<String> getTermsOfUse() async {
    if (_termsOfUse.isNotEmpty) return _termsOfUse;

    HttpieResponse response = await _httpService.get(termsOfUsePolicyUrl);
    _termsOfUse = response.body;
    return _termsOfUse;
  }
}
