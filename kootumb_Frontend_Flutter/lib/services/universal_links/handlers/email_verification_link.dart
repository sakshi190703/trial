import 'dart:async';

import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/auth_api.dart';
import 'package:Kootumb/services/toast.dart';
import 'package:Kootumb/services/universal_links/universal_links.dart';
import 'package:Kootumb/services/user.dart';
import 'package:flutter/material.dart';

import '../../localization.dart';

class EmailVerificationLinkHandler extends UniversalLinkHandler {
  static const String verifyEmailLink = '/api/auth/email/verify';
  late StreamSubscription _onLoggedInUserChangeSubscription;

  @override
  Future handle({required BuildContext context, required String link}) async {
    if (link.contains(verifyEmailLink)) {
      final token = _getEmailVerificationTokenFromLink(link);
      KongoProviderState kongoProvider = KongoProvider.of(context);
      UserService userService = kongoProvider.userService;
      ToastService toastService = kongoProvider.toastService;
      AuthApiService authApiService = kongoProvider.authApiService;
      LocalizationService localizationService =
          kongoProvider.localizationService;

      _onLoggedInUserChangeSubscription =
          userService.loggedInUserChange.listen((User? newUser) async {
        _onLoggedInUserChangeSubscription.cancel();

        try {
          HttpieResponse response =
              await authApiService.verifyEmailWithToken(token);
          if (response.isOk()) {
            toastService.success(
                message:
                    localizationService.user__email_verification_successful,
                context: context);
          } else if (response.isBadRequest()) {
            toastService.error(
                message: localizationService.user__email_verification_error,
                context: context);
          }
        } on HttpieConnectionRefusedError {
          toastService.error(
              message: localizationService.error__no_internet_connection,
              context: context);
        } catch (e) {
          toastService.error(
              message: localizationService.error__unknown_error,
              context: context);
          rethrow;
        }
      });
    }
  }

  String _getEmailVerificationTokenFromLink(String link) {
    final linkParts = _getDeepLinkParts(link);
    return linkParts[linkParts.length - 1];
  }

  List<String> _getDeepLinkParts(String link) {
    final uri = Uri.parse(link);
    return uri.path.split('/');
  }
}
