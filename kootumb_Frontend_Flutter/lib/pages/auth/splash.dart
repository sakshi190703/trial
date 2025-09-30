import 'package:Kootumb/pages/auth/create_account/blocs/create_account.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/buttons/secondary_button.dart';
import 'package:flutter/material.dart';

class OBAuthSplashPage extends StatefulWidget {
  const OBAuthSplashPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBAuthSplashPageState();
  }
}

class OBAuthSplashPageState extends State<OBAuthSplashPage> {
  late LocalizationService localizationService;
  late CreateAccountBloc createAccountBloc;

  @override
  Widget build(BuildContext context) {
    var kongoProvider = KongoProvider.of(context);
    localizationService = kongoProvider.localizationService;
    createAccountBloc = kongoProvider.createAccountBloc;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/kootumbBlue1.png'),
                fit: BoxFit.fill),
            color: Color.fromARGB(255, 0, 0, 254)),
        padding: EdgeInsets.symmetric(horizontal: 40.0),
        // child: Center(child: SingleChildScrollView(child: _buildLogo())),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
    return BottomAppBar(
      color: Color.fromARGB(255, 0, 0, 254),
      elevation: 0.0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(child: _buildCreateAccountButton(context: context)),
            Expanded(
              child: _buildLoginButton(context: context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    String headlineText = localizationService.trans('auth__headline');

    return Column(
      children: <Widget>[
        // OBSplashLogo(),
        // const SizedBox(
        //   height: 20.0,
        // ),
        // Text(headlineText,
        //     textAlign: TextAlign.center,
        //     style: TextStyle(
        //       fontSize: 22.0,
        //       //color: Colors.white
        //     ))
      ],
    );
  }

  Widget _buildLoginButton({required BuildContext context}) {
    String buttonText = localizationService.trans('auth__login');

    return OBSecondaryButton(
      isLarge: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            buttonText,
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          )
        ],
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/auth/child_safety');
      },
    );
  }

  Widget _buildCreateAccountButton({required BuildContext context}) {
    String buttonText = localizationService.trans('auth__create_account');

    return OBSecondaryButton(
      isLarge: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            buttonText,
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          )
        ],
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/auth/get-started');
      },
    );
  }
}
