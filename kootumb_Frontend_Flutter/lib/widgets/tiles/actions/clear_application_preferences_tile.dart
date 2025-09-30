import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/theming/secondary_text.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:Kootumb/widgets/tiles/loading_tile.dart';
import 'package:flutter/material.dart';

class OBClearApplicationPreferencesTile extends StatefulWidget {
  const OBClearApplicationPreferencesTile({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBClearApplicationPreferencesTileState();
  }
}

class OBClearApplicationPreferencesTileState
    extends State<OBClearApplicationPreferencesTile> {
  late bool _inProgress;

  @override
  initState() {
    super.initState();
    _inProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    LocalizationService localizationService =
        KongoProvider.of(context).localizationService;
    return OBLoadingTile(
      leading: OBIcon(OBIcons.clear),
      title: OBText(localizationService.user__clear_app_preferences_title),
      subtitle:
          OBSecondaryText(localizationService.user__clear_app_preferences_desc),
      isLoading: _inProgress,
      onTap: () => _clearApplicationPreferences(localizationService),
    );
  }

  Future _clearApplicationPreferences(
      LocalizationService localizationService) async {
    KongoProviderState kongoProvider = KongoProvider.of(context);
    try {
      await kongoProvider.userPreferencesService.clear();
      kongoProvider.toastService.success(
          message: localizationService
              .user__clear_app_preferences_cleared_successfully,
          context: context);
    } catch (error) {
      kongoProvider.toastService.error(
          message: localizationService.user__clear_app_preferences_error,
          context: context);
      rethrow;
    } finally {
      _setInProgress(false);
    }
  }

  void _setInProgress(bool inProgress) {
    setState(() {
      _inProgress = inProgress;
    });
  }
}
