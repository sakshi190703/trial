import 'package:Kootumb/services/httpie.dart';

class ConnectionsApiService {
  late HttpieService _httpService;

  String? apiURL = "http://10.0.2.2:8000/";

  static const CONNECT_WITH_USER_PATH = 'api/connections/connect/';
  static const DISCONNECT_FROM_USER_PATH = 'api/connections/disconnect/';
  static const UPDATE_CONNECTION_PATH = 'api/connections/update/';
  static const CONFIRM_CONNECTION_PATH = 'api/connections/confirm/';

  void setHttpService(HttpieService httpService) {
    _httpService = httpService;
  }

  void setApiURL(String newApiURL) {
    apiURL = newApiURL;
  }

  Future<HttpieResponse> connectWithUserWithUsername(String username,
      {List<int>? circlesIds}) {
    Map<String, dynamic> body = {'username': username};

    if (circlesIds != null) body['circles_ids'] = circlesIds;

    return _httpService.postJSON('$apiURL$CONNECT_WITH_USER_PATH',
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> confirmConnectionWithUserWithUsername(String username,
      {List<int>? circlesIds}) {
    Map<String, dynamic> body = {'username': username};

    if (circlesIds != null) body['circles_ids'] = circlesIds;

    return _httpService.postJSON('$apiURL$CONFIRM_CONNECTION_PATH',
        body: body, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> disconnectFromUserWithUsername(String username) {
    return _httpService.postJSON('$apiURL$DISCONNECT_FROM_USER_PATH',
        body: {'username': username}, appendAuthorizationToken: true);
  }

  Future<HttpieResponse> updateConnectionWithUsername(String username,
      {List<int>? circlesIds}) {
    Map<String, dynamic> body = {'username': username};

    if (circlesIds != null) body['circles_ids'] = circlesIds;

    return _httpService.postJSON('$apiURL$UPDATE_CONNECTION_PATH',
        body: body, appendAuthorizationToken: true);
  }
}
