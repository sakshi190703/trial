import 'dart:io';

import 'package:Kootumb/models/post_image.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OBPostImagePreviewer extends StatelessWidget {
  final PostImage? postImage;

  const OBPostImagePreviewer(
      {Key? key,
      this.postImage,
      File? file,
      required Null Function() onRemove,
      required Null Function() onWillEditImage,
      required Null Function(File editedImage) onPostImageEdited})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isFileImage = postImage?.file != null;
    final File? postImageFile = postImage?.file;
    final double avatarBorderRadius = 8.0;

    return SizedBox(
      height: 200.0,
      width: 200.0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(avatarBorderRadius),
        child: isFileImage
            ? Image.file(
                postImageFile!,
                fit: BoxFit.cover,
              )
            : CachedNetworkImage(
                imageUrl: postImage?.image ?? '',
                fit: BoxFit.cover,
                placeholder: (context, url) => Image.asset(
                  'assets/images/fallbacks/post-fallback.png',
                  fit: BoxFit.cover,
                ),
                errorWidget: (context, url, error) => Image.asset(
                  'assets/images/fallbacks/post-fallback.png',
                  fit: BoxFit.cover,
                ),
              ),
      ),
    );
  }
}

extension on PostImage? {
  Null get file => null;
}
