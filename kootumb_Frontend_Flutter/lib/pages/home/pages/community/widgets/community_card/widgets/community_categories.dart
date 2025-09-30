import 'package:Kootumb/models/category.dart';
import 'package:Kootumb/models/community.dart';
import 'package:Kootumb/widgets/category_badge.dart';
import 'package:flutter/material.dart';

class OBCommunityCategories extends StatelessWidget {
  final Community community;

  const OBCommunityCategories(this.community, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: community,
      stream: community.updateSubject,
      builder: (BuildContext context, AsyncSnapshot<Community> snapshot) {
        Community community = snapshot.data!;
        if (community.categories == null) return const SizedBox();
        List<Category> categories = community.categories!.categories!;

        List<Widget> connectionItems = [];

        for (var category in categories) {
          connectionItems.add(Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              OBCategoryBadge(
                category: category,
                size: OBCategoryBadgeSize.small,
              )
            ],
          ));
        }

        return Padding(
          padding: EdgeInsets.only(top: 10),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: connectionItems,
          ),
        );
      },
    );
  }
}
