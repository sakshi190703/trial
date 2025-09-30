import 'package:Kootumb/pages/home/pages/hashtag/widgets/cupertino_nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// A coloured navigation bar, used in communities.
class OBImageNavBar extends StatelessWidget
    implements ObstructingPreferredSizeWidget {
  final String imageSrc;
  final Color? textColor;
  final Widget? leading;
  final Widget? middle;
  final Widget? trailing;
  final String? title;

  const OBImageNavBar(
      {Key? key,
      required this.imageSrc,
      this.leading,
      this.trailing,
      this.title,
      this.textColor,
      this.middle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          top: 0,
          child: CachedNetworkImage(
            imageUrl: imageSrc,
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
        OBCupertinoNavigationBar(
            leading: leading,
            actionsForegroundColor: Colors.white,
            middle: middle ??
                Text(
                  title ?? '',
                  style: TextStyle(color: textColor ?? Colors.white),
                ),
            transitionBetweenRoutes: false,
            backgroundColor: Color.fromRGBO(0, 0, 0, 0.65),
            trailing: trailing),
      ],
    );
  }

  bool get fullObstruction => true;

  @override
  Size get preferredSize {
    return const Size.fromHeight(44);
  }

  @override
  bool shouldFullyObstruct(BuildContext context) {
    return true;
  }
}
