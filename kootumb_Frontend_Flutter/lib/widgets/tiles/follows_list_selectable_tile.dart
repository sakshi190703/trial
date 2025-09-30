import 'package:Kootumb/models/post.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OBNotificationTilePostMediaPreview extends StatelessWidget {
  static final double postMediaPreviewSize = 40;
  final Post post;

  const OBNotificationTilePostMediaPreview({Key? key, required this.post})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: SizedBox(
        height: postMediaPreviewSize,
        width: postMediaPreviewSize,
        child: CachedNetworkImage(
          imageUrl: post.mediaThumbnail ?? '',
          fit: BoxFit.cover,
          placeholder: (context, url) => const SizedBox(),
          errorWidget: (context, url, error) => Image.asset(
            'assets/images/fallbacks/post-fallback.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
