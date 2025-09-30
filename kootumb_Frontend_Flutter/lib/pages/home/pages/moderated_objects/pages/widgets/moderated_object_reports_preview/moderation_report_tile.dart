import 'package:Kootumb/models/moderation/moderation_report.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/avatars/avatar.dart';
import 'package:Kootumb/widgets/theming/secondary_text.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBModerationReportTile extends StatelessWidget {
  final ModerationReport report;

  const OBModerationReportTile({Key? key, required this.report})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocalizationService localizationService =
        KongoProvider.of(context).localizationService;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildReportCategory(report, localizationService),
              const SizedBox(
                height: 5,
              ),
              _buildReportDescription(report, localizationService),
              const SizedBox(
                height: 5,
              ),
              _buildReportReporter(report: report, context: context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReportReporter(
      {required ModerationReport report, required BuildContext context}) {
    LocalizationService localizationService =
        KongoProvider.of(context).localizationService;
    return GestureDetector(
        onTap: () {
          KongoProviderState kongoProvider = KongoProvider.of(context);
          kongoProvider.navigationService
              .navigateToUserProfile(user: report.reporter!, context: context);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            OBText(
              localizationService.moderation__reporter_text,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: <Widget>[
                  OBAvatar(
                    borderRadius: 4,
                    customSize: 16,
                    avatarUrl: report.reporter!.getProfileAvatar(),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  OBSecondaryText(
                    '@${report.reporter!.username!}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ));
  }

  Widget _buildReportDescription(
      ModerationReport report, LocalizationService localizationService) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        OBText(
          localizationService.moderation__description_text,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        OBSecondaryText(
          report.description != null
              ? report.description!
              : localizationService.moderation__no_description_text,
          style: TextStyle(
              fontStyle: report.description == null
                  ? FontStyle.italic
                  : FontStyle.normal),
        ),
      ],
    );
  }

  Widget _buildReportCategory(
      ModerationReport report, LocalizationService localizationService) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        OBText(
          localizationService.moderation__category_text,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        OBSecondaryText(
          report.category!.title!,
        ),
      ],
    );
  }
}
