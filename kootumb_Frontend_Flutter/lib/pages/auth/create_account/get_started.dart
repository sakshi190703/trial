import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/buttons/button.dart';
import 'package:Kootumb/widgets/buttons/success_button.dart';
import 'package:Kootumb/widgets/buttons/secondary_button.dart';
import 'package:flutter/material.dart';

class OBAuthGetStartedPage extends StatefulWidget {
  const OBAuthGetStartedPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBAuthGetStartedPageState();
  }
}

class OBAuthGetStartedPageState extends State<OBAuthGetStartedPage> {
  late LocalizationService _localizationService;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var kongoProvider = KongoProvider.of(context);
    _localizationService = kongoProvider.localizationService;

    String previousText = _localizationService.auth__create_acc__previous;
    String nextText = _localizationService.auth__create_acc__next;

    return Scaffold(
      backgroundColor: Color(0xFF151726),
      body: DecoratedBox(
        decoration: _buildGetStartedDecoration(),
        child:
            Center(child: SingleChildScrollView(child: _buildLetsGetStarted())),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0.0,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child:
                    _buildPreviousButton(context: context, text: previousText),
              ),
              Expanded(
                  child: _buildNextButton(context: context, text: nextText)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLetsGetStarted() {
    String getStartedText =
        _localizationService.auth__create_acc__lets_get_started;
    String welcomeText = _localizationService.auth__create_acc__welcome_to_beta;

    return Column(
      children: <Widget>[
        Text(
          '🚀',
          style: TextStyle(fontSize: 45.0, color: Colors.white),
        ),
        const SizedBox(
          height: 20.0,
        ),
        Text(welcomeText,
            style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        SizedBox(
          height: 20.0,
        ),
        Text(getStartedText,
            style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ],
    );
  }

  BoxDecoration _buildGetStartedDecoration() {
    return BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/pixel-universe.jpg'),
            fit: BoxFit.cover));
  }

  Widget _buildNextButton(
      {required BuildContext context, required String text}) {
    return OBSuccessButton(
      minWidth: double.infinity,
      size: OBButtonSize.large,
      child: Text(text, style: TextStyle(fontSize: 18.0)),
      onPressed: () {
        Navigator.pushNamed(context, '/auth/name_step');
      },
    );
  }

  Widget _buildPreviousButton(
      {required BuildContext context, required String text}) {
    return OBSecondaryButton(
      isFullWidth: true,
      isLarge: true,
      child: Row(
        children: <Widget>[
          Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          const SizedBox(
            width: 10.0,
          ),
          Text(
            text,
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
