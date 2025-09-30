import 'package:Kootumb/models/circle.dart';
import 'package:Kootumb/pages/home/pages/menu/pages/connections_circle/widgets/connections_circle_header/widgets/connections_circle_name.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/circle_color_preview.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../provider.dart';

class OBConnectionsCircleHeader extends StatelessWidget {
  final Circle connectionsCircle;
  final bool isConnectionsCircle;

  const OBConnectionsCircleHeader(this.connectionsCircle,
      {Key? key, this.isConnectionsCircle = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: connectionsCircle.updateSubject,
        initialData: connectionsCircle,
        builder: (BuildContext context, AsyncSnapshot<Circle> snapshot) {
          var connectionsCircle = snapshot.data!;
          LocalizationService localizationService =
              KongoProvider.of(context).localizationService;

          List<Widget> columnItems = [_buildCircleName(connectionsCircle)];

          if (isConnectionsCircle) {
            columnItems
                .add(_buildConnectionsCircleDescription(localizationService));
          }

          columnItems.add(_buildUsersHeader(localizationService));

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: columnItems,
          );
        });
  }

  Widget _buildCircleName(Circle connectionsCircle) {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20, top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: OBConnectionsCircleName(connectionsCircle),
          ),
          OBCircleColorPreview(
            connectionsCircle,
            size: OBCircleColorPreviewSize.large,
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionsCircleDescription(
      LocalizationService localizationService) {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, right: 20, top: 10.0, bottom: 20),
      child: Column(
        children: <Widget>[
          OBText(localizationService
              .trans('user__connections_header_circle_desc')),
        ],
      ),
    );
  }

  Widget _buildUsersHeader(LocalizationService localizationService) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20),
      child: OBText(localizationService.trans('user__connections_header_users'),
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
    );
  }
}
