import 'package:Kootumb/pages/auth/create_account/blocs/create_account.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/buttons/button.dart';
import 'package:Kootumb/widgets/buttons/secondary_button.dart';
import 'package:Kootumb/widgets/buttons/success_button.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class OBAcceptStepPage extends StatefulWidget {
  const OBAcceptStepPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBAcceptStepPageState();
  }
}

class OBAcceptStepPageState extends State<OBAcceptStepPage> {
  late CreateAccountBloc _createAccountBloc;
  late LocalizationService _localizationService;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var kongoProvider = KongoProvider.of(context);
    _localizationService = kongoProvider.localizationService;
    _createAccountBloc = kongoProvider.createAccountBloc;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  children: <Widget>[
                    _buildConfirmLegalAgeText(),
                  ],
                ))),
      ),
      backgroundColor: Pigment.fromString('#007d9c'),
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

  Widget _buildConfirmLegalAgeText() {
    return Column(
      children: <Widget>[
        SizedBox(width: 10.0),
        Text(
          '👩‍⚖️',
          style: TextStyle(fontSize: 45.0, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 20.0,
        ),
        Text(
          _localizationService.auth__create_acc__legal_confirmation,
          style: TextStyle(
              fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          _localizationService.auth__create_acc__legal_confirmation_desc,
          style: TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildNextButton() {
    return OBSuccessButton(
      minWidth: double.infinity,
      size: OBButtonSize.large,
      child: Text(_localizationService.trans('auth__create_acc__register'),
          style: TextStyle(fontSize: 18.0)),
      onPressed: () {
        _createAccountBloc.setLegalAgeConfirmation(true);
        Navigator.pushNamed(context, '/auth/submit_step');
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
