import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/services/toast.dart';
import 'package:Kootumb/services/utils_service.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../../../../../provider.dart';

class OBProfileAge extends StatefulWidget {
  final User user;

  const OBProfileAge(this.user, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBProfileAgeState();
  }
}

class OBProfileAgeState extends State<OBProfileAge> {
  late LocalizationService _localizationService;
  late ToastService _toastService;
  late UtilsService _utilsService;
  late bool _needsBootstrap;
  static const MIN_AGE_IN_YEARS_FOR_ADULT = 1;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
  }

  @override
  Widget build(BuildContext context) {
    DateTime? age = widget.user.dateJoined;

    if (age == null) {
      return const SizedBox();
    }

    if (_needsBootstrap) {
      var kongoProvider = KongoProvider.of(context);
      _utilsService = kongoProvider.utilsService;
      _localizationService = kongoProvider.localizationService;
      _toastService = kongoProvider.toastService;
      _bootstrap();
      _needsBootstrap = false;
    }

    String shortenedAge = _utilsService.timeAgo(age, _localizationService);
    String formattedAgeDate = DateFormat.yMMMMd().format(age);

    return GestureDetector(
      onTap: () async {
        _toastService.info(
          context: context,
          message: _localizationService.user__profile_kootumb_age_toast(
            formattedAgeDate,
          ),
        );
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          OBIcon(
            _getIsUserBaby()
                ? OBIcons.kootumb_age_baby
                : OBIcons.kootumb_age_smile,
            customSize: 17.0,
          ),
          const SizedBox(width: 10),
          Flexible(child: OBText(shortenedAge, maxLines: 1)),
        ],
      ),
    );
  }

  bool _getIsUserBaby() {
    DateTime? dateJoined = widget.user.dateJoined;
    if (dateJoined == null) return false;

    DateTime now = DateTime.now();
    Duration difference = now.difference(dateJoined);
    if ((difference.inDays / 365).floor() >= MIN_AGE_IN_YEARS_FOR_ADULT) {
      return false;
    }

    return true;
  }

  void _bootstrap() async {
    await _utilsService.initialiseDateFormatting(_localizationService);
  }
}
