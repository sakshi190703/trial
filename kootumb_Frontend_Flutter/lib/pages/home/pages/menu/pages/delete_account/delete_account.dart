import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/services/navigation_service.dart';
import 'package:Kootumb/services/validation.dart';
import 'package:Kootumb/widgets/buttons/button.dart';
import 'package:Kootumb/widgets/fields/text_form_field.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/icon_button.dart';
import 'package:Kootumb/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Kootumb/widgets/page_scaffold.dart';
import 'package:Kootumb/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBDeleteAccountPage extends StatefulWidget {
  const OBDeleteAccountPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBDeleteAccountPageState();
  }
}

class OBDeleteAccountPageState extends State<OBDeleteAccountPage> {
  late ValidationService _validationService;
  late NavigationService _navigationService;
  late LocalizationService _localizationService;

  static const double INPUT_ICONS_SIZE = 16;
  static const EdgeInsetsGeometry INPUT_CONTENT_PADDING = EdgeInsets.symmetric(
    vertical: 15.0,
    horizontal: 20.0,
  );
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _formWasSubmitted = false;
  bool _formValid = true;
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _formWasSubmitted = false;
    _formValid = true;
    _currentPasswordController.addListener(_updateFormValid);
    _newPasswordController.addListener(_updateFormValid);
  }

  @override
  Widget build(BuildContext context) {
    var kongoProvider = KongoProvider.of(context);
    _validationService = kongoProvider.validationService;
    _navigationService = kongoProvider.navigationService;
    _localizationService = kongoProvider.localizationService;

    return OBCupertinoPageScaffold(
      navigationBar: _buildNavigationBar(),
      child: OBPrimaryColorContainer(
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                OBTextFormField(
                  size: OBTextFormFieldSize.large,
                  autofocus: true,
                  obscureText: true,
                  controller: _currentPasswordController,
                  decoration: InputDecoration(
                    labelText:
                        _localizationService.user__delete_account_current_pwd,
                    hintText: _localizationService
                        .user__delete_account_current_pwd_hint,
                  ),
                  validator: (String? password) {
                    if (!_formWasSubmitted) return null;
                    String? validatePassword =
                        _validationService.validateUserPassword(password);
                    return validatePassword;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ObstructingPreferredSizeWidget _buildNavigationBar() {
    return OBThemedNavigationBar(
      title: _localizationService.user__delete_account_title,
      trailing: OBButton(
        isDisabled: !_formValid,
        size: OBButtonSize.small,
        onPressed: _submitForm,
        child: Text(_localizationService.user__delete_account_next),
      ),
      leading: OBIconButton(
        OBIcons.close,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  bool _validateForm() {
    return _formKey.currentState?.validate() ?? false;
  }

  bool _updateFormValid() {
    var formValid = _validateForm();
    _setFormValid(formValid);
    return formValid;
  }

  void _submitForm() async {
    _formWasSubmitted = true;
    var formIsValid = _updateFormValid();
    if (!formIsValid) return;

    var result = await _navigationService.navigateToConfirmDeleteAccount(
      userPassword: _currentPasswordController.text,
      context: context,
    );
    if (result is bool && !result) {
      _currentPasswordController.clear();
    }
  }

  void _setFormValid(bool formValid) {
    setState(() {
      _formValid = formValid;
    });
  }
}
