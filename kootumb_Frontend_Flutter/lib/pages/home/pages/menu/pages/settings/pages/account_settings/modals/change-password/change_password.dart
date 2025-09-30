import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/services/toast.dart';
import 'package:Kootumb/services/user.dart';
import 'package:Kootumb/services/validation.dart';
import 'package:Kootumb/widgets/buttons/button.dart';
import 'package:Kootumb/widgets/fields/text_form_field.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Kootumb/widgets/page_scaffold.dart';
import 'package:Kootumb/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBChangePasswordModal extends StatefulWidget {
  const OBChangePasswordModal({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBChangePasswordModalState();
  }
}

class OBChangePasswordModalState extends State<OBChangePasswordModal> {
  late ValidationService _validationService;
  late ToastService _toastService;
  late UserService _userService;
  late LocalizationService _localizationService;
  static const double INPUT_ICONS_SIZE = 16;
  static const EdgeInsetsGeometry INPUT_CONTENT_PADDING = EdgeInsets.symmetric(
    vertical: 15.0,
    horizontal: 20.0,
  );
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _requestInProgress = false;
  bool _formWasSubmitted = false;
  bool? _isPasswordValid = true;
  bool _formValid = true;
  late final TextEditingController _currentPasswordController =
      TextEditingController();
  late final TextEditingController _newPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _requestInProgress = false;
    _formWasSubmitted = false;
    _isPasswordValid = true;
    _formValid = true;
    _currentPasswordController.addListener(_updateFormValid);
    _newPasswordController.addListener(_updateFormValid);
  }

  @override
  Widget build(BuildContext context) {
    var kongoProvider = KongoProvider.of(context);
    _validationService = kongoProvider.validationService;
    _toastService = kongoProvider.toastService;
    _userService = kongoProvider.userService;
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
                        _localizationService.auth__change_password_current_pwd,
                    hintText: _localizationService
                        .auth__change_password_current_pwd_hint,
                  ),
                  validator: (String? password) {
                    if (!_formWasSubmitted) return null;
                    if (_isPasswordValid != null && !_isPasswordValid!) {
                      _setIsPasswordValid(true);
                      return _localizationService
                          .auth__change_password_current_pwd_incorrect;
                    }
                    String? validatePassword =
                        _validationService.validateUserPassword(password);
                    return validatePassword;

                    return null;
                  },
                ),
                OBTextFormField(
                  autofocus: false,
                  obscureText: true,
                  controller: _newPasswordController,
                  size: OBTextFormFieldSize.large,
                  decoration: InputDecoration(
                    labelText:
                        _localizationService.auth__change_password_new_pwd,
                    hintText:
                        _localizationService.auth__change_password_new_pwd_hint,
                  ),
                  validator: (String? newPassword) {
                    if (!_formWasSubmitted) return null;
                    if (!_validationService.isPasswordAllowedLength(
                      newPassword ?? '',
                    )) {
                      return _localizationService
                          .auth__change_password_new_pwd_error;
                    }
                    return null;
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
      leading: GestureDetector(
        child: const OBIcon(OBIcons.close),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      title: _localizationService.auth__change_password_title,
      trailing: OBButton(
        isDisabled: !_formValid,
        isLoading: _requestInProgress,
        size: OBButtonSize.small,
        onPressed: _submitForm,
        child: Text(_localizationService.auth__change_password_save_text),
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
    _setRequestInProgress(true);
    try {
      var currentPassword = _currentPasswordController.text;
      var newPassword = _newPasswordController.text;
      await _userService.updateUserPassword(currentPassword, newPassword);
      _toastService.success(
        message: _localizationService.auth__change_password_save_success,
        context: context,
      );
      Navigator.of(context).pop();
    } catch (error) {
      _onError(error);
    } finally {
      _setRequestInProgress(false);
    }
  }

  void _onError(error) async {
    if (error is HttpieConnectionRefusedError) {
      _toastService.error(
        message: error.toHumanReadableMessage(),
        context: context,
      );
    } else if (error is HttpieRequestError) {
      HttpieBaseResponse response = error.response;
      if (response.isUnauthorized()) {
        // Meaning password didnt match
        _setIsPasswordValid(false);
        _validateForm();
      }
      String? errorMessage = await error.toHumanReadableMessage();
      _toastService.error(
        message: errorMessage ?? _localizationService.error__unknown_error,
        context: context,
      );
    } else {
      _toastService.error(
        message: _localizationService.error__unknown_error,
        context: context,
      );
      throw error;
    }
  }

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }

  void _setIsPasswordValid(bool isPasswordValid) {
    setState(() {
      _isPasswordValid = isPasswordValid;
    });
  }

  void _setFormValid(bool formValid) {
    setState(() {
      _formValid = formValid;
    });
  }
}
