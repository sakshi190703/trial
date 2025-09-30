import 'package:Kootumb/models/emoji.dart';
import 'package:Kootumb/models/follows_list.dart';
import 'package:Kootumb/models/user.dart';
import 'package:Kootumb/pages/home/modals/save_follows_list/pages/pick_follows_list_emoji.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/toast.dart';
import 'package:Kootumb/services/user.dart';
import 'package:Kootumb/services/validation.dart';
import 'package:Kootumb/widgets/buttons/button.dart';
import 'package:Kootumb/widgets/fields/emoji_field.dart';
import 'package:Kootumb/widgets/fields/text_form_field.dart';
import 'package:Kootumb/widgets/routes/slide_right_route.dart';
import 'package:Kootumb/widgets/theming/primary_color_container.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:Kootumb/widgets/tiles/user_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBSaveFollowsListModal extends StatefulWidget {
  final FollowsList? followsList;
  final bool autofocusNameTextField;

  const OBSaveFollowsListModal(
      {Key? key, this.followsList, this.autofocusNameTextField = false})
      : super(key: key);

  @override
  OBSaveFollowsListModalState createState() {
    return OBSaveFollowsListModalState();
  }
}

class OBSaveFollowsListModalState extends State<OBSaveFollowsListModal> {
  static const double INPUT_EMOJIS_SIZE = 16;

  late UserService _userService;
  late ToastService _toastService;
  late ValidationService _validationService;
  late LocalizationService _localizationService;

  late bool _requestInProgress;
  late bool _formWasSubmitted;
  late bool _formValid;
  late bool _hasExistingList;
  String? _takenFollowsListName;
  late List<User> _users;

  late GlobalKey<FormState> _formKey;

  late TextEditingController _nameController;
  Emoji? _emoji;

  @override
  void initState() {
    super.initState();
    _formValid = true;
    _requestInProgress = false;
    _formWasSubmitted = false;
    _nameController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _hasExistingList = widget.followsList != null;
    _users = _hasExistingList && widget.followsList!.hasUsers()
        ? widget.followsList!.users!.users!.toList()
        : [];

    if (_hasExistingList) {
      _nameController.text = widget.followsList!.name!;
      _emoji = widget.followsList!.emoji;
    }

    _nameController.addListener(_updateFormValid);
  }

  @override
  Widget build(BuildContext context) {
    var kongoProvider = KongoProvider.of(context);
    _userService = kongoProvider.userService;
    _toastService = kongoProvider.toastService;
    _localizationService = kongoProvider.localizationService;
    _validationService = kongoProvider.validationService;

    return Scaffold(
        appBar: _buildNavigationBar(),
        body: OBPrimaryColorContainer(
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: <Widget>[
                            OBTextFormField(
                                textCapitalization:
                                    TextCapitalization.sentences,
                                size: OBTextFormFieldSize.large,
                                autofocus: widget.autofocusNameTextField,
                                controller: _nameController,
                                decoration: InputDecoration(
                                    labelText: _localizationService
                                        .user__save_follows_list_name,
                                    hintText: _localizationService
                                        .user__save_follows_list_hint_text),
                                validator: (String? followsListName) {
                                  if (!_formWasSubmitted) return null;

                                  if (_takenFollowsListName != null &&
                                      _takenFollowsListName ==
                                          followsListName) {
                                    return _localizationService
                                        .user__save_follows_list_name_taken(
                                            _takenFollowsListName!);
                                  }

                                  return _validationService
                                      .validateFollowsListName(followsListName);
                                }),
                            OBEmojiField(
                                emoji: _emoji,
                                onEmojiFieldTapped: (Emoji? emoji) =>
                                    _onWantsToPickEmoji(),
                                labelText: _localizationService
                                    .user__save_follows_list_emoji,
                                errorText: _formWasSubmitted && _emoji == null
                                    ? _localizationService
                                        .user__save_follows_list_emoji_required_error
                                    : null),
                          ],
                        )),
                    _users.isNotEmpty
                        ? Padding(
                            padding: EdgeInsets.only(
                                left: 20, top: 20, bottom: 20.0),
                            child: OBText(
                              _localizationService
                                  .user__save_follows_list_users,
                              style: TextStyle(fontWeight: FontWeight.bold),
                              size: OBTextSize.large,
                            ),
                          )
                        : const SizedBox(),
                    Column(
                        children: _users.map((User user) {
                      return OBUserTile(
                        user,
                        showFollowing: false,
                        onUserTileDeleted: (User user) {
                          setState(() {
                            _users.remove(user);
                          });
                        },
                      );
                    }).toList())
                  ],
                )),
          ),
        ));
  }

  ObstructingPreferredSizeWidget _buildNavigationBar() {
    return OBThemedNavigationBar(
        leading: GestureDetector(
          child: const OBIcon(OBIcons.close),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: _hasExistingList
            ? _localizationService.user__save_follows_list_edit
            : _localizationService.user__save_follows_list_create,
        trailing: OBButton(
          isDisabled: !_formValid,
          isLoading: _requestInProgress,
          size: OBButtonSize.small,
          onPressed: _submitForm,
          child: Text(_localizationService.user__save_follows_list_save),
        ));
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
      var followsListName = _nameController.text;
      bool followsListNameTaken =
          await _isFollowsListNameTaken(followsListName);

      if (followsListNameTaken) {
        _setTakenFollowsListName(followsListName);
        _validateForm();
        return;
      }

      FollowsList followsList = await (_hasExistingList
          ? _userService.updateFollowsList(widget.followsList!,
              name: _nameController.text != widget.followsList!.name
                  ? _nameController.text
                  : null,
              users: _users,
              emoji: _emoji)
          : _userService.createFollowsList(
              name: _nameController.text, emoji: _emoji));

      Navigator.of(context).pop(followsList);
    } catch (error) {
      _onError(error);
    } finally {
      _setRequestInProgress(false);
    }
  }

  void _onError(error) async {
    if (error is HttpieConnectionRefusedError) {
      _toastService.error(
          message: error.toHumanReadableMessage(), context: context);
    } else if (error is HttpieRequestError) {
      String? errorMessage = await error.toHumanReadableMessage();
      _toastService.error(
          message: errorMessage ?? _localizationService.error__unknown_error,
          context: context);
    } else {
      _toastService.error(
          message: _localizationService.error__unknown_error, context: context);
      throw error;
    }
  }

  Future<bool> _isFollowsListNameTaken(String followsListName) async {
    if (_hasExistingList && widget.followsList!.name == _nameController.text) {
      return false;
    }
    return _validationService.isFollowsListNameTaken(followsListName);
  }

  void _onWantsToPickEmoji() async {
    Emoji? pickedEmoji = await Navigator.push(
      context,
      OBSlideRightRoute<Emoji>(
          builder: (BuildContext context) {
            return OBPickFollowsListEmojiPage();
          },
          slidableKey: Key('obPickEmojiFollowsList')),
    );

    if (pickedEmoji != null) _onPickedEmoji(pickedEmoji);
  }

  void _onPickedEmoji(Emoji pickedEmoji) {
    _setEmoji(pickedEmoji);
  }

  void _setEmoji(Emoji emoji) {
    setState(() {
      _emoji = emoji;
    });
  }

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }

  void _setFormValid(bool formValid) {
    setState(() {
      _formValid = formValid;
    });
  }

  void _setTakenFollowsListName(String takenFollowsListName) {
    setState(() {
      _takenFollowsListName = takenFollowsListName;
    });
  }
}
