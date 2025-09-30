import 'dart:io';

import 'package:Kootumb/models/category.dart';
import 'package:Kootumb/models/community.dart';
import 'package:Kootumb/services/media/media.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/services/theme_value_parser.dart';
import 'package:Kootumb/widgets/avatars/letter_avatar.dart';
import 'package:Kootumb/widgets/cover.dart';
import 'package:Kootumb/widgets/fields/categories_field.dart';
import 'package:Kootumb/widgets/fields/color_field.dart';
import 'package:Kootumb/widgets/fields/community_type_field.dart';
import 'package:Kootumb/widgets/fields/toggle_field.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/nav_bars/colored_nav_bar.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/toast.dart';
import 'package:Kootumb/services/user.dart';
import 'package:Kootumb/services/validation.dart';
import 'package:Kootumb/widgets/buttons/button.dart';
import 'package:Kootumb/widgets/fields/text_form_field.dart';
import 'package:Kootumb/widgets/progress_indicator.dart';
import 'package:Kootumb/widgets/theming/primary_color_container.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pigment/pigment.dart';

class OBSaveCommunityModal extends StatefulWidget {
  final Community? community;

  const OBSaveCommunityModal({Key? key, this.community}) : super(key: key);

  @override
  OBSaveCommunityModalState createState() {
    return OBSaveCommunityModalState();
  }
}

class OBSaveCommunityModalState extends State<OBSaveCommunityModal> {
  late UserService _userService;
  late ToastService _toastService;
  late ValidationService _validationService;
  late MediaService _imagePickerService;
  late LocalizationService _localizationService;
  late ThemeValueParserService _themeValueParserService;

  late bool _requestInProgress;
  late bool _formWasSubmitted;
  late bool _formValid;
  late bool _isEditingExistingCommunity;
  String? _takenName;

  late GlobalKey<FormState> _formKey;

  late TextEditingController _nameController;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _userAdjectiveController;
  late TextEditingController _usersAdjectiveController;
  late TextEditingController _rulesController;
  late OBCategoriesFieldController _categoriesFieldController;

  String? _color;
  CommunityType? _type;
  String? _avatarUrl;
  String? _coverUrl;
  File? _avatarFile;
  File? _coverFile;
  bool? _invitesEnabled;

  late List<Category> _categories;

  @override
  void initState() {
    super.initState();
    _formValid = true;
    _requestInProgress = false;
    _formWasSubmitted = false;
    _nameController = TextEditingController();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _userAdjectiveController = TextEditingController();
    _usersAdjectiveController = TextEditingController();
    _rulesController = TextEditingController();
    _categoriesFieldController = OBCategoriesFieldController();
    _type = CommunityType.public;
    _invitesEnabled = true;
    _categories = [];

    _formKey = GlobalKey<FormState>();
    _isEditingExistingCommunity = widget.community != null;

    if (_isEditingExistingCommunity) {
      _nameController.text = widget.community!.name ?? '';
      _titleController.text = widget.community!.title ?? '';
      _descriptionController.text = widget.community!.description ?? '';
      _userAdjectiveController.text = widget.community!.userAdjective ?? '';
      _usersAdjectiveController.text = widget.community!.usersAdjective ?? '';
      _rulesController.text = widget.community!.rules ?? '';
      _color = widget.community!.color;
      _categories = widget.community!.categories?.categories?.toList() ?? [];
      _type = widget.community!.type;
      _avatarUrl = widget.community!.avatar;
      _coverUrl = widget.community!.cover;
      _invitesEnabled = widget.community!.invitesEnabled;
    }

    _nameController.addListener(_updateFormValid);
    _titleController.addListener(_updateFormValid);
    _descriptionController.addListener(_updateFormValid);
    _userAdjectiveController.addListener(_updateFormValid);
    _usersAdjectiveController.addListener(_updateFormValid);
    _rulesController.addListener(_updateFormValid);
  }

  @override
  Widget build(BuildContext context) {
    var kongoProvider = KongoProvider.of(context);
    _userService = kongoProvider.userService;
    _toastService = kongoProvider.toastService;
    _validationService = kongoProvider.validationService;
    _imagePickerService = kongoProvider.mediaService;
    _localizationService = kongoProvider.localizationService;
    _themeValueParserService = kongoProvider.themeValueParserService;
    var themeService = kongoProvider.themeService;

    _color = _color ?? themeService.generateRandomHexColor();

    return CupertinoPageScaffold(
      navigationBar: _buildNavigationBar(),
      child: OBPrimaryColorContainer(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    _buildCover(),
                    Positioned(
                      left: 20,
                      child: Column(
                        children: <Widget>[
                          const SizedBox(
                            height: (OBCover.largeSizeHeight) -
                                (OBAvatar.AVATAR_SIZE_LARGE / 2),
                          ),
                          _buildAvatar(),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: OBCover.largeSizeHeight +
                          OBAvatar.AVATAR_SIZE_LARGE / 2,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 40),
                  child: Column(
                    children: <Widget>[
                      OBTextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        size: OBTextFormFieldSize.medium,
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: _localizationService
                              .community__save_community_label_title,
                          hintText: _localizationService
                              .community__save_community_label_title_hint_text,
                          prefixIcon: const OBIcon(OBIcons.communities),
                        ),
                        validator: (String? communityTitle) {
                          return _validationService.validateCommunityTitle(
                            communityTitle,
                          );
                        },
                      ),
                      OBTextFormField(
                        textCapitalization: TextCapitalization.none,
                        size: OBTextFormFieldSize.medium,
                        controller: _nameController,
                        autocorrect: false,
                        decoration: InputDecoration(
                          prefixIcon: const OBIcon(OBIcons.shortText),
                          labelText: _localizationService
                              .community__save_community_name_title,
                          prefixText: 'c/',
                          hintText: _localizationService
                              .community__save_community_name_title_hint_text,
                        ),
                        validator: (String? communityName) {
                          if (_takenName != null &&
                              _takenName == communityName) {
                            return _localizationService
                                .community__save_community_name_taken(
                              _takenName!,
                            );
                          }

                          return _validationService.validateCommunityName(
                            communityName,
                          );
                        },
                      ),
                      OBColorField(
                        initialColor: _color,
                        onNewColor: _onNewColor,
                        labelText: _localizationService
                            .community__save_community_name_label_color,
                        hintText: _localizationService
                            .community__save_community_name_label_color_hint_text,
                      ),
                      OBCommunityTypeField(
                        value: _type!,
                        title: _localizationService
                            .community__save_community_name_label_type,
                        hintText: _localizationService
                            .community__save_community_name_label_type_hint_text,
                        onChanged: (CommunityType type) {
                          setState(() {
                            _type = type;
                          });
                        },
                      ),
                      _type == CommunityType.private
                          ? OBToggleField(
                              value: _invitesEnabled ?? false,
                              title: _localizationService
                                  .community__save_community_name_member_invites,
                              subtitle: OBText(
                                _localizationService
                                    .community__save_community_name_member_invites_subtitle,
                              ),
                              onChanged: (bool value) {
                                setState(() {
                                  _invitesEnabled = value;
                                });
                              },
                              onTap: () {
                                setState(() {
                                  _invitesEnabled = !(_invitesEnabled ?? false);
                                });
                              },
                            )
                          : const SizedBox(),
                      OBCategoriesField(
                        title: _localizationService
                            .community__save_community_name_category,
                        min: 1,
                        max: 3,
                        controller: _categoriesFieldController,
                        displayErrors: _formWasSubmitted,
                        onChanged: _onCategoriesChanged,
                        initialCategories: _categories,
                      ),
                      OBTextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        size: OBTextFormFieldSize.medium,
                        controller: _descriptionController,
                        maxLines: 3,
                        textInputAction: TextInputAction.newline,
                        decoration: InputDecoration(
                          prefixIcon: const OBIcon(
                            OBIcons.communityDescription,
                          ),
                          labelText: _localizationService
                              .community__save_community_name_label_desc_optional,
                          hintText: _localizationService
                              .community__save_community_name_label_desc_optional_hint_text,
                        ),
                        validator: (String? communityDescription) {
                          return _validationService
                              .validateCommunityDescription(
                            communityDescription,
                          );
                        },
                      ),
                      OBTextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        size: OBTextFormFieldSize.medium,
                        controller: _rulesController,
                        decoration: InputDecoration(
                          prefixIcon: const OBIcon(OBIcons.communityRules),
                          labelText: _localizationService
                              .community__save_community_name_label_rules_optional,
                          hintText: _localizationService
                              .community__save_community_name_label_rules_optional_hint_text,
                        ),
                        validator: (String? communityRules) {
                          return _validationService.validateCommunityRules(
                            communityRules,
                          );
                        },
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        maxLines: 3,
                      ),
                      OBTextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        size: OBTextFormFieldSize.medium,
                        controller: _userAdjectiveController,
                        decoration: InputDecoration(
                          prefixIcon: const OBIcon(OBIcons.communityMember),
                          labelText: _localizationService
                              .community__save_community_name_label_member_adjective,
                          hintText: _localizationService
                              .community__save_community_name_label_member_adjective_hint_text,
                        ),
                        validator: (String? communityUserAdjective) {
                          return _validationService
                              .validateCommunityUserAdjective(
                            communityUserAdjective,
                          );
                        },
                      ),
                      OBTextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        size: OBTextFormFieldSize.medium,
                        controller: _usersAdjectiveController,
                        decoration: InputDecoration(
                          prefixIcon: const OBIcon(OBIcons.communityMembers),
                          labelText: _localizationService
                              .community__save_community_name_label_members_adjective,
                          hintText: _localizationService
                              .community__save_community_name_label_members_adjective_hint_text,
                        ),
                        validator: (String? communityUsersAdjective) {
                          return _validationService
                              .validateCommunityUserAdjective(
                            communityUsersAdjective,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ObstructingPreferredSizeWidget _buildNavigationBar() {
    Color color = _themeValueParserService.parseColor(_color!);
    bool isDarkColor = _themeValueParserService.isDarkColor(color);
    Color actionsColor = isDarkColor ? Colors.white : Colors.black;

    return OBColoredNavBar(
      color: color,
      leading: GestureDetector(
        child: OBIcon(OBIcons.close, color: actionsColor),
        onTap: () {
          Navigator.pop(context);
        },
      ),
      title: _isEditingExistingCommunity
          ? _localizationService.community__save_community_edit_community
          : _localizationService.community__save_community_create_community,
      trailing: _requestInProgress
          ? OBProgressIndicator(color: actionsColor)
          : OBButton(
              isDisabled: !_formValid,
              isLoading: _requestInProgress,
              size: OBButtonSize.small,
              onPressed: _submitForm,
              child: Text(
                _isEditingExistingCommunity
                    ? _localizationService.community__save_community_save_text
                    : _localizationService
                        .community__save_community_create_text,
              ),
            ),
    );
  }

  Widget _buildAvatar() {
    bool hasAvatarFile = _avatarFile != null;
    bool hasAvatarUrl = _avatarUrl != null;

    bool hasAvatar = hasAvatarFile || hasAvatarUrl;

    VoidCallback onPressed = hasAvatar ? _clearAvatar : _pickNewAvatar;

    Widget icon = Icon(hasAvatar ? Icons.clear : Icons.edit, size: 15);

    Widget avatar;

    if (hasAvatar) {
      avatar = OBAvatar(
        borderWidth: 3,
        avatarUrl: _avatarUrl,
        avatarFile: _avatarFile,
        size: OBAvatarSize.large,
      );
    } else {
      avatar = OBLetterAvatar(
        size: OBAvatarSize.large,
        color: Pigment.fromString(_color!),
        letter: _nameController.text.isEmpty ? 'C' : _nameController.text[0],
      );
    }

    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        children: <Widget>[
          avatar,
          Positioned(
            bottom: 10,
            right: 10,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 30, maxHeight: 30),
              child: FloatingActionButton(
                heroTag: Key('editCommunityAvatar'),
                backgroundColor: Colors.white,
                onPressed: onPressed,
                child: icon,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _pickNewAvatar() async {
    File? newAvatar = await _imagePickerService.pickImage(
      imageType: OBImageType.avatar,
      context: context,
    );
    _setAvatarFile(newAvatar);
  }

  Widget _buildCover() {
    bool hasCoverFile = _coverFile != null;
    bool hasCoverUrl = _coverUrl != null;
    bool hasCover = hasCoverFile || hasCoverUrl;

    VoidCallback onPressed = hasCover ? _clearCover : _pickNewCover;

    Widget icon = Icon(hasCover ? Icons.clear : Icons.edit, size: 15);

    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        children: <Widget>[
          OBCover(coverUrl: _coverUrl, coverFile: _coverFile),
          Positioned(
            bottom: 20,
            right: 20,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 40, maxHeight: 40),
              child: FloatingActionButton(
                heroTag: Key('editCommunityCover'),
                backgroundColor: Colors.white,
                onPressed: onPressed,
                child: icon,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _pickNewCover() async {
    File? newCover = await _imagePickerService.pickImage(
      imageType: OBImageType.cover,
      context: context,
    );
    _setCoverFile(newCover);
  }

  void _onCategoriesChanged(List<Category> categories) {
    _setCategories(categories);
    // TODO Couldnt find a way to make it work without doing this
    // Perhaps move the entire state of the CategoriesField into here
    _updateFormValid();
  }

  void _clearAvatar() {
    _avatarUrl = null;
    _clearAvatarFile();
  }

  void _clearAvatarFile() {
    _setAvatarFile(null);
  }

  void _setAvatarFile(File? avatarFile) {
    setState(() {
      _avatarFile = avatarFile;
    });
  }

  void _clearCover() {
    _coverUrl = null;
    _clearCoverFile();
  }

  void _clearCoverFile() {
    _setCoverFile(null);
  }

  void _setCoverFile(File? coverFile) {
    setState(() {
      _coverFile = coverFile;
    });
  }

  bool _validateForm() {
    return _formKey.currentState?.validate() ?? false;
  }

  bool _updateFormValid() {
    if (!_formWasSubmitted) return true;
    var formValid = _validateForm() && _categoriesFieldController.isValid();
    _setFormValid(formValid);
    return formValid;
  }

  void _submitForm() async {
    _formWasSubmitted = true;

    var formIsValid = _updateFormValid();

    if (!formIsValid) return;

    _setRequestInProgress(true);
    try {
      var communityName = _nameController.text;
      bool communityNameTaken = await _isNameTaken(communityName);

      if (communityNameTaken) {
        _setTakenName(communityName);
        _validateForm();
        return;
      }

      Community community = await (_isEditingExistingCommunity
          ? _updateCommunity()
          : _createCommunity());

      Navigator.of(context).pop(community);
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

  Future<Community> _updateCommunity() async {
    await _updateCommunityAvatar();
    await _updateCommunityCover();

    return _userService.updateCommunity(
      widget.community!,
      name: _nameController.text != widget.community!.name
          ? _nameController.text
          : null,
      title: _titleController.text,
      description: _descriptionController.text,
      rules: _rulesController.text,
      userAdjective: _userAdjectiveController.text,
      usersAdjective: _usersAdjectiveController.text,
      categories: _categories,
      type: _type,
      invitesEnabled: _invitesEnabled,
      color: _color,
    );
  }

  Future<void> _updateCommunityCover() {
    bool hasCoverFile = _coverFile != null;
    bool hasCoverUrl = _coverUrl != null;
    bool hasCover = hasCoverFile || hasCoverUrl;

    Future<void>? updateFuture;

    if (!hasCover) {
      if (widget.community?.cover != null) {
        // Remove cover!
        updateFuture = _userService.deleteCoverForCommunity(widget.community!);
      }
    } else if (hasCoverFile) {
      // New cover
      updateFuture = _userService.updateCoverForCommunity(
        widget.community!,
        cover: _coverFile!,
      );
    } else {
      updateFuture = Future.value();
    }

    return updateFuture ?? Future.value();
  }

  Future<void> _updateCommunityAvatar() {
    bool hasAvatarFile = _avatarFile != null;
    bool hasAvatarUrl = _avatarUrl != null;
    bool hasAvatar = hasAvatarFile || hasAvatarUrl;

    Future<void>? updateFuture;

    if (!hasAvatar) {
      if (widget.community!.avatar != null) {
        // Remove avatar!
        updateFuture = _userService.deleteAvatarForCommunity(widget.community!);
      }
    } else if (hasAvatarFile) {
      // New avatar
      updateFuture = _userService.updateAvatarForCommunity(
        widget.community!,
        avatar: _avatarFile!,
      );
    } else {
      updateFuture = Future.value();
    }

    return updateFuture ?? Future.value();
  }

  Future<Community> _createCommunity() {
    return _userService.createCommunity(
      type: _type ?? CommunityType.public,
      name: _nameController.text,
      title: _titleController.text,
      description: _descriptionController.text,
      rules: _rulesController.text,
      userAdjective: _userAdjectiveController.text,
      usersAdjective: _usersAdjectiveController.text,
      categories: _categories,
      invitesEnabled: _invitesEnabled,
      color: _color,
      avatar: _avatarFile,
      cover: _coverFile,
    );
  }

  Future<bool> _isNameTaken(String communityName) async {
    if (_isEditingExistingCommunity &&
        widget.community?.name == _nameController.text) {
      return false;
    }
    return _validationService.isCommunityNameTaken(communityName);
  }

  void _onNewColor(String newColor) {
    _setColor(newColor);
  }

  void _setColor(String color) {
    setState(() {
      _color = color;
    });
  }

  void _setCategories(List<Category> categories) {
    setState(() {
      _categories = categories;
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

  void _setTakenName(String takenCommunityName) {
    setState(() {
      _takenName = takenCommunityName;
    });
  }
}
