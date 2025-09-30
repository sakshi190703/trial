import 'package:Kootumb/models/category.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/services/theme_value_parser.dart';
import 'package:Kootumb/widgets/tabs/image_tab.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OBCategoryTab extends StatelessWidget {
  final Category category;

  const OBCategoryTab({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeValueParserService themeValueParser =
        KongoProvider.of(context).themeValueParserService;

    Color categoryColor = themeValueParser.parseColor(category.color!);
    bool categoryColorIsDark = themeValueParser.isDarkColor(categoryColor);

    return OBImageTab(
      text: category.title!,
      color: categoryColor,
      textColor: categoryColorIsDark ? Colors.white : Colors.black,
      imageProvider: CachedNetworkImageProvider(
        category.avatar ?? '',
      ),
    );
  }
}
