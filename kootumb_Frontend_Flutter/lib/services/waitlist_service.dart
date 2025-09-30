import 'package:Kootumb/services/httpie.dart';

class WaitlistApiService {
  late HttpieService _httpService;
  late String kongoSocialApiURL;

  static const MAILCHIMP_SUBSCRIBE_PATH = 'waitlist/subscribe/';
  static const HEALTH_PATH = 'health/';

  void setKongoSocialApiURL(String newApiURL) {
    kongoSocialApiURL = newApiURL;
  }

  void setHttpService(HttpieService httpService) {
    _httpService = httpService;
  }

  Future<HttpieResponse> subscribeToBetaWaitlist({String? email}) {
    var body = {};
    if (email != null && email != '') {
      body['email'] = email;
    }
    return _httpService.postJSON('$kongoSocialApiURL$MAILCHIMP_SUBSCRIBE_PATH',
        body: body);
  }
}
