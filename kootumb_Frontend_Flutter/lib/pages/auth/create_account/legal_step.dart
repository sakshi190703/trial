import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/buttons/button.dart';
import 'package:Kootumb/widgets/buttons/secondary_button.dart';
import 'package:Kootumb/widgets/buttons/success_button.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class OBLegalStepPage extends StatefulWidget {
  const OBLegalStepPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBLegalStepPageState();
  }
}

class OBLegalStepPageState extends State<OBLegalStepPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late LocalizationService _localizationService;
  late var _urlLauncherService;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var kongoProvider = KongoProvider.of(context);
    _localizationService = kongoProvider.localizationService;
    _urlLauncherService = kongoProvider.urlLauncherService;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        SizedBox(width: 10.0),
                        Text(
                          '📖️',
                          style: TextStyle(fontSize: 45.0, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          _localizationService.auth__create_acc__legal,
                          style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          _localizationService.auth__create_acc__legal_desc,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          _localizationService
                              .auth__create_acc__legal_desc_extra,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        _buildDocuments(),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ],
                ))),
      ),
      backgroundColor: Pigment.fromString('#009c53'),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0.0,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: _buildPreviousButton(context: context),
              ),
              Expanded(child: _buildNextButton()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocuments() {
    return ListView(
      shrinkWrap: true,
      children: [
        _buildDocument(
            icon: '📋',
            title: "Kootumb Policies",
            onPressed: () => _urlLauncherService
                .launchUrlInApp('https://kootumb.com/policies.html')),
        const SizedBox(
          height: 10,
        ),
        _buildDocument(
            icon: '🏡',
            title:
                _localizationService.drawer__useful_links_community_guidelines,
            onPressed: () => _urlLauncherService
                .launchUrlInApp('https://kootumb.com/policies.html')),
        const SizedBox(
          height: 10,
        ),
        _buildDocument(
            icon: '⚖️',
            title: _localizationService.drawer__useful_links_terms_of_use,
            onPressed: () => _urlLauncherService
                .launchUrlInApp('https://kootumb.com/policies.html')),
        const SizedBox(
          height: 10,
        ),
        _buildDocument(
            icon: '🔒',
            title: _localizationService.drawer__useful_links_privacy_policy,
            onPressed: () => _urlLauncherService
                .launchUrlInApp('https://kootumb.com/policies.html'))
      ],
    );
  }

  Widget _buildDocument(
      {required String icon,
      required String title,
      required VoidCallback onPressed}) {
    return GestureDetector(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(30, 255, 255, 255),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Text(
                  icon,
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                OBIcon(
                  OBIcons.chevronRight,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ));
  }

  Widget _buildNextButton() {
    return OBSuccessButton(
      minWidth: double.infinity,
      size: OBButtonSize.large,
      child: Text(_localizationService.auth__create_acc__next,
          style: TextStyle(fontSize: 18.0)),
      onPressed: () {
        Navigator.pushNamed(context, '/auth/accept_step');
      },
    );
  }

  Widget _buildPreviousButton({required BuildContext context}) {
    String buttonText =
        _localizationService.trans('auth__create_acc__previous');

    return OBSecondaryButton(
      isFullWidth: true,
      isLarge: true,
      child: Row(
        children: <Widget>[
          Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(
            buttonText,
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          )
        ],
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
