import 'package:Kootumb/models/post_image.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/widgets/icon.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OBPostBodyImage extends StatelessWidget {
  final PostImage? postImage;
  final bool hasExpandButton;
  final double? height;
  final double? width;

  const OBPostBodyImage(
      {Key? key,
      this.postImage,
      this.hasExpandButton = false,
      this.height,
      this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imageUrl = postImage!.image!;

    List<Widget> stackItems = [
      _buildImageWidget(imageUrl: imageUrl, width: width!, height: height!)
    ];

    if (hasExpandButton) {
      stackItems.add(_buildExpandIcon());
    }

    return GestureDetector(
      child: Stack(
        children: stackItems,
      ),
      onTap: () {
        var dialogService = KongoProvider.of(context).dialogService;
        dialogService.showZoomablePhotoBoxView(
            imageUrl: imageUrl, context: context);
      },
    );
  }

  Widget _buildImageWidget({String? imageUrl, double? height, double? width}) {
    return CachedNetworkImage(
      imageUrl: imageUrl ?? '',
      height: height,
      width: width,
      fit: BoxFit.cover,
      placeholder: (context, url) => Image.asset(
        'assets/images/fallbacks/post-fallback.png',
        height: height,
        width: width,
        fit: BoxFit.cover,
      ),
      errorWidget: (context, url, error) => Image.asset(
        'assets/images/fallbacks/post-fallback.png',
        height: height,
        width: width,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildExpandIcon() {
    return Positioned(
        bottom: 15,
        right: 15,
        child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              //Same dark grey as in OBZoomablePhotoModal
              color: Colors.black87,
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: OBIcon(
              OBIcons.expand,
              customSize: 12,
            )));
  }
}
