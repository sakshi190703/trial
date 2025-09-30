import 'package:Kootumb/pages/auth/create_account/blocs/create_account.dart';
import 'package:Kootumb/plugins/proxy_settings.dart';
import 'package:Kootumb/services/auth_api.dart';
import 'package:Kootumb/services/bottom_sheet.dart';
import 'package:Kootumb/services/categories_api.dart';
import 'package:Kootumb/services/communities_api.dart';
import 'package:Kootumb/services/connections_circles_api.dart';
import 'package:Kootumb/services/connections_api.dart';
import 'package:Kootumb/services/connectivity.dart';
import 'package:Kootumb/services/date_picker.dart';
import 'package:Kootumb/services/devices_api.dart';
import 'package:Kootumb/services/dialog.dart';
import 'package:Kootumb/services/documents.dart';
import 'package:Kootumb/services/draft.dart';
import 'package:Kootumb/services/explore_timeline_preferences.dart';
import 'package:Kootumb/services/hashtags_api.dart';
import 'package:Kootumb/services/intercom.dart';
import 'package:Kootumb/services/moderation_api.dart';
import 'package:Kootumb/services/media/media.dart';
import 'package:Kootumb/services/notifications_api.dart';
import 'package:Kootumb/services/permissions.dart';
import 'package:Kootumb/services/push_notifications/push_notifications.dart';
import 'package:Kootumb/services/share.dart';
import 'package:Kootumb/services/text_autocompletion.dart';
import 'package:Kootumb/services/universal_links/universal_links.dart';
import 'package:Kootumb/services/emoji_picker.dart';
import 'package:Kootumb/services/emojis_api.dart';
import 'package:Kootumb/services/environment_loader.dart';
import 'package:Kootumb/services/follows_api.dart';
import 'package:Kootumb/services/follows_lists_api.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/services/modal_service.dart';
import 'package:Kootumb/services/navigation_service.dart';
import 'package:Kootumb/services/posts_api.dart';
import 'package:Kootumb/services/storage.dart';
import 'package:Kootumb/services/string_template.dart';
import 'package:Kootumb/services/theme.dart';
import 'package:Kootumb/services/theme_value_parser.dart';
import 'package:Kootumb/services/toast.dart';
import 'package:Kootumb/services/url_launcher.dart';
import 'package:Kootumb/services/user.dart';
import 'package:Kootumb/services/user_invites_api.dart';
import 'package:Kootumb/services/user_preferences.dart';
import 'package:Kootumb/services/utils_service.dart';
import 'package:Kootumb/services/validation.dart';
import 'package:Kootumb/services/waitlist_service.dart';
import 'package:flutter/material.dart';
import 'package:sentry/sentry.dart';

// TODO Waiting for dependency injection support
// https://github.com/flutter/flutter/issues/21980

class KongoProvider extends StatefulWidget {
  final Widget child;

  const KongoProvider({Key? key, required this.child}) : super(key: key);

  @override
  KongoProviderState createState() {
    return KongoProviderState();
  }

  static KongoProviderState of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<_KongoProvider>();
    if (provider == null) {
      throw FlutterError('KongoProvider not found in widget tree');
    }
    return provider.data!;
  }
}

class KongoProviderState extends State<KongoProvider> {
  UserPreferencesService userPreferencesService = UserPreferencesService();
  ExploreTimelinePreferencesService exploreTimelinePreferencesService =
      ExploreTimelinePreferencesService();
  CreateAccountBloc createAccountBloc = CreateAccountBloc();
  ValidationService validationService = ValidationService();
  HttpieService httpService = HttpieService();
  AuthApiService authApiService = AuthApiService();
  PostsApiService postsApiService = PostsApiService();
  StorageService storageService = StorageService();
  UserService userService = UserService();
  ModerationApiService moderationApiService = ModerationApiService();
  ToastService toastService = ToastService();
  StringTemplateService stringTemplateService = StringTemplateService();
  EmojisApiService emojisApiService = EmojisApiService();
  ThemeService themeService = ThemeService();
  MediaService mediaService = MediaService();
  ShareService shareService = ShareService();
  DatePickerService datePickerService = DatePickerService();
  EmojiPickerService emojiPickerService = EmojiPickerService();
  FollowsApiService followsApiService = FollowsApiService();
  PermissionsService permissionService = PermissionsService();
  CommunitiesApiService communitiesApiService = CommunitiesApiService();
  HashtagsApiService hashtagsApiService = HashtagsApiService();
  CategoriesApiService categoriesApiService = CategoriesApiService();
  NotificationsApiService notificationsApiService = NotificationsApiService();
  DevicesApiService devicesApiService = DevicesApiService();
  ConnectionsApiService connectionsApiService = ConnectionsApiService();
  ConnectionsCirclesApiService connectionsCirclesApiService =
      ConnectionsCirclesApiService();
  FollowsListsApiService followsListsApiService = FollowsListsApiService();
  UserInvitesApiService userInvitesApiService = UserInvitesApiService();
  ThemeValueParserService themeValueParserService = ThemeValueParserService();
  ModalService modalService = ModalService();
  NavigationService navigationService = NavigationService();
  WaitlistApiService waitlistApiService = WaitlistApiService();

  late LocalizationService localizationService;
  UniversalLinksService universalLinksService = UniversalLinksService();
  BottomSheetService bottomSheetService = BottomSheetService();
  PushNotificationsService pushNotificationsService =
      PushNotificationsService();
  UrlLauncherService urlLauncherService = UrlLauncherService();
  IntercomService intercomService = IntercomService();
  DialogService dialogService = DialogService();
  UtilsService utilsService = UtilsService();
  DocumentsService documentsService = DocumentsService();
  TextAutocompletionService textAccountAutocompletionService =
      TextAutocompletionService();
  ConnectivityService connectivityService = ConnectivityService();
  DraftService draftService = DraftService();

  late SentryClient sentryClient;

  @override
  void initState() {
    super.initState();
    initAsyncState();
    imageCache.maximumSize = 200 << 20; // 200MB
    userPreferencesService.setStorageService(storageService);
    userPreferencesService.setConnectivityService(connectivityService);
    exploreTimelinePreferencesService.setStorageService(storageService);
    connectionsCirclesApiService.setHttpService(httpService);
    httpService.setUtilsService(utilsService);
    connectionsCirclesApiService
        .setStringTemplateService(stringTemplateService);
    communitiesApiService.setHttpieService(httpService);
    communitiesApiService.setStringTemplateService(stringTemplateService);
    followsListsApiService.setHttpService(httpService);
    followsListsApiService.setStringTemplateService(stringTemplateService);
    userInvitesApiService.setHttpService(httpService);
    userInvitesApiService.setStringTemplateService(stringTemplateService);
    connectionsApiService.setHttpService(httpService);
    authApiService.setHttpService(httpService);
    authApiService.setStringTemplateService(stringTemplateService);
    followsApiService.setHttpService(httpService);
    createAccountBloc.setAuthApiService(authApiService);
    createAccountBloc.setUserService(userService);
    userService.setAuthApiService(authApiService);
    userService.setHashtagsApiService(hashtagsApiService);
    userService.setPushNotificationsService(pushNotificationsService);
    userService.setIntercomService(intercomService);
    userService.setPostsApiService(postsApiService);
    userService.setEmojisApiService(emojisApiService);
    userService.setHttpieService(httpService);
    userService.setStorageService(storageService);
    userService.setUserInvitesApiService(userInvitesApiService);
    userService.setFollowsApiService(followsApiService);
    userService.setFollowsListsApiService(followsListsApiService);
    userService.setConnectionsApiService(connectionsApiService);
    userService.setConnectionsCirclesApiService(connectionsCirclesApiService);
    userService.setCommunitiesApiService(communitiesApiService);
    userService.setCategoriesApiService(categoriesApiService);
    userService.setNotificationsApiService(notificationsApiService);
    userService.setDevicesApiService(devicesApiService);
    userService.setCreateAccountBlocService(createAccountBloc);
    userService.setWaitlistApiService(waitlistApiService);
    userService.setDraftService(draftService);
    waitlistApiService.setHttpService(httpService);
    userService.setModerationApiService(moderationApiService);
    emojisApiService.setHttpService(httpService);
    categoriesApiService.setHttpService(httpService);
    postsApiService.setHttpieService(httpService);
    postsApiService.setStringTemplateService(stringTemplateService);
    notificationsApiService.setHttpService(httpService);
    notificationsApiService.setStringTemplateService(stringTemplateService);
    devicesApiService.setHttpService(httpService);
    devicesApiService.setStringTemplateService(stringTemplateService);
    validationService.setAuthApiService(authApiService);
    validationService.setUtilsService(utilsService);
    validationService.setFollowsListsApiService(followsListsApiService);
    validationService.setCommunitiesApiService(communitiesApiService);
    validationService
        .setConnectionsCirclesApiService(connectionsCirclesApiService);
    themeService.setStorageService(storageService);
    themeService.setUtilsService(utilsService);
    pushNotificationsService.setUserService(userService);
    pushNotificationsService.setStorageService(storageService);
    intercomService.setUserService(userService);
    dialogService.setThemeService(themeService);
    dialogService.setThemeValueParserService(themeValueParserService);
    mediaService.setValidationService(validationService);
    mediaService.setBottomSheetService(bottomSheetService);
    mediaService.setPermissionsService(permissionService);
    mediaService.setUtilsService(utilsService);
    documentsService.setHttpService(httpService);
    moderationApiService.setStringTemplateService(stringTemplateService);
    moderationApiService.setHttpieService(httpService);
    shareService.setMediaService(mediaService);
    shareService.setToastService(toastService);
    shareService.setValidationService(validationService);
    permissionService.setToastService(toastService);
    hashtagsApiService.setHttpieService(httpService);
    hashtagsApiService.setStringTemplateService(stringTemplateService);
    textAccountAutocompletionService.setValidationService(validationService);
  }

  void initAsyncState() async {
    Environment environment =
        await EnvironmentLoader(environmentPath: "assets/.env.json").load();
    httpService.setMagicHeader(
        environment.magicHeaderName, environment.magicHeaderValue);

    // Only set proxy if we have a valid API URL
    if (environment.apiUrl.isNotEmpty) {
      try {
        httpService.setProxy(
            await ProxySettings.findProxy(Uri.parse(environment.apiUrl)));
      } catch (e) {
        print('Failed to set proxy: $e');
      }
    }
    authApiService.setApiURL(environment.apiUrl);
    postsApiService.setApiURL(environment.apiUrl);
    emojisApiService.setApiURL(environment.apiUrl);
    userInvitesApiService.setApiURL(environment.apiUrl);
    followsApiService.setApiURL(environment.apiUrl);
    moderationApiService.setApiURL(environment.apiUrl);
    connectionsApiService.setApiURL(environment.apiUrl);
    connectionsCirclesApiService.setApiURL(environment.apiUrl);
    followsListsApiService.setApiURL(environment.apiUrl);
    communitiesApiService.setApiURL(environment.apiUrl);
    hashtagsApiService.setApiURL(environment.apiUrl);
    categoriesApiService.setApiURL(environment.apiUrl);
    notificationsApiService.setApiURL(environment.apiUrl);
    devicesApiService.setApiURL(environment.apiUrl);
    waitlistApiService.setKongoSocialApiURL(environment.kongoSocialApiUrl);
    intercomService.bootstrap(
        iosApiKey: environment.intercomIosKey,
        androidApiKey: environment.intercomAndroidKey,
        appId: environment.intercomAppId);
    if (environment.sentryDsn.isNotEmpty == true) {
      sentryClient = SentryClient(SentryOptions(dsn: environment.sentryDsn));
    }
    utilsService.setTrustedProxyUrl(environment.linkPreviewsTrustedProxyUrl);

    await connectivityService.bootstrap();
    documentsService.preload();
    userPreferencesService.bootstrap();
  }

  @override
  Widget build(BuildContext context) {
    return _KongoProvider(
      data: this,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    super.dispose();
    universalLinksService.dispose();
    pushNotificationsService.dispose();
    connectivityService.dispose();
    userPreferencesService.dispose();
  }

  void setLocalizationService(LocalizationService newLocalizationService) {
    localizationService = newLocalizationService;
    createAccountBloc.setLocalizationService(localizationService);
    httpService.setLocalizationService(localizationService);
    userService.setLocalizationsService(localizationService);
    modalService.setLocalizationService(localizationService);
    userPreferencesService.setLocalizationService(localizationService);
    shareService.setLocalizationService(localizationService);
    mediaService.setLocalizationService(localizationService);
    permissionService.setLocalizationService(localizationService);
  }

  void setValidationService(ValidationService newValidationService) {
    validationService = newValidationService;
  }
}

class _KongoProvider extends InheritedWidget {
  final KongoProviderState? data;

  const _KongoProvider({Key? key, this.data, required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(_KongoProvider old) {
    return true;
  }
}
