import 'package:Kootumb/pages/auth/create_account/blocs/create_account.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/universal_links/universal_links.dart';
import 'package:Kootumb/services/user.dart';
import 'package:flutter/material.dart';

class CreateAccountLinkHandler extends UniversalLinkHandler {
  static const String createAccountLink = '/api/auth/invite';

  @override
  Future<void> handle(
      {required BuildContext context, required String link}) async {
    if (link.contains(createAccountLink)) {
      KongoProviderState kongoProvider = KongoProvider.of(context);
      UserService userService = kongoProvider.userService;
      if (userService.isLoggedIn()) {
        print('User already logged in. Doing nothing with create account link');
      } else {
        print(
            'User not yet logged in. Sending to create account route with token');
        final String token = _getAccountCreationTokenFromLink(link);
        CreateAccountBloc createAccountBloc = kongoProvider.createAccountBloc;
        createAccountBloc.setToken(token);
        Navigator.pushReplacementNamed(context, '/auth/get-started');
      }
    }
  }

  String _getAccountCreationTokenFromLink(String link) {
    final params = Uri.parse(link).queryParametersAll;
    var token = '';
    if (params.containsKey('token')) {
      token = params['token']![0];
    }
    return token;
  }
}
