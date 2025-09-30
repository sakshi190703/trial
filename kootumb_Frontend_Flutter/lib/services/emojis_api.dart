import 'package:Kootumb/services/httpie.dart';

class EmojisApiService {
  late HttpieService _httpService;

  String? apiURL = "http://10.0.2.2:8000/";

  static const GET_EMOJI_GROUPS_PATH = 'api/emojis/groups/';

  void setHttpService(HttpieService httpService) {
    _httpService = httpService;
  }

  void setApiURL(String newApiURL) {
    apiURL = newApiURL;
  }

  Future<HttpieResponse> getEmojiGroups() {
    String url = _makeApiUrl(GET_EMOJI_GROUPS_PATH);
    return _httpService.get(url, appendAuthorizationToken: true);
  }

  String _makeApiUrl(String string) {
    return '$apiURL$string';
  }
}
