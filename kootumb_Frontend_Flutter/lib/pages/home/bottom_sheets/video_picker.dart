import 'dart:io';
import 'package:Kootumb/pages/home/bottom_sheets/rounded_bottom_sheet.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/localization.dart';
import 'package:Kootumb/services/media/media.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:Kootumb/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBVideoPickerBottomSheet extends StatelessWidget {
  const OBVideoPickerBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = KongoProvider.of(context);
    var imagePicker = ImagePicker();

    LocalizationService localizationService = provider.localizationService;

    List<Widget> videoPickerActions = [
      ListTile(
        leading: const OBIcon(OBIcons.gallery),
        title: OBText(
          localizationService.video_picker__from_gallery,
        ),
        onTap: () async {
          bool permissionGranted = await provider.permissionService
              .requestStoragePermissions(context: context);
          if (permissionGranted) {
            XFile? pickedFile =
                await imagePicker.pickVideo(source: ImageSource.gallery);

            if (pickedFile != null) {
              File file = File(pickedFile.path);
              Navigator.pop(context, file);
              return;
            }
          }
          Navigator.pop(context, null);
          ListTile(
            leading: const OBIcon(OBIcons.camera),
            title: OBText(
              localizationService.video_picker__from_camera,
            ),
            onTap: () async {
              XFile? pickedFile =
                  await imagePicker.pickVideo(source: ImageSource.camera);
              File? pickedVideo =
                  pickedFile != null ? File(pickedFile.path) : null;
              Navigator.pop(context, pickedVideo);
            },
          );
        },
      )
    ];

    return OBRoundedBottomSheet(
        child: Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: videoPickerActions,
      ),
    ));
  }
}
