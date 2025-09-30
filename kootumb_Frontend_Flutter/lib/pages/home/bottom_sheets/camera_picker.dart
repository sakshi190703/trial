import 'dart:io';
import 'package:Kootumb/pages/home/bottom_sheets/rounded_bottom_sheet.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/services/media/media.dart';
import 'package:Kootumb/services/media/models/media_file.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class OBCameraPickerBottomSheet extends StatelessWidget {
  const OBCameraPickerBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = KongoProvider.of(context);
    var imagePicker = ImagePicker();

    LocalizationService localizationService = provider.localizationService;

    List<Widget> cameraPickerActions = [
      ListTile(
        leading: const OBIcon(OBIcons.camera),
        title: OBText(
          localizationService.post__create_photo,
        ),
        onTap: () async {
          bool permissionGranted = await provider.permissionService
              .requestStoragePermissions(context: context);
          if (permissionGranted) {
            XFile? pickedFile =
                await imagePicker.pickImage(source: ImageSource.camera);
            File? file = pickedFile != null ? File(pickedFile.path) : null;
            Navigator.pop(
                context, file != null ? MediaFile(file, FileType.image) : null);
          }
        },
      ),
      ListTile(
        leading: const OBIcon(OBIcons.video_camera),
        title: OBText(
          localizationService.post__create_video,
        ),
        onTap: () async {
          bool permissionGranted = await provider.permissionService
              .requestStoragePermissions(context: context);
          if (permissionGranted) {
            XFile? pickedFile =
                await imagePicker.pickVideo(source: ImageSource.camera);
            File? file = pickedFile != null ? File(pickedFile.path) : null;
            Navigator.pop(
                context, file != null ? MediaFile(file, FileType.video) : null);
          }
        },
      ),
    ];

    return OBRoundedBottomSheet(
        child: Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: cameraPickerActions,
      ),
    ));
  }
}
