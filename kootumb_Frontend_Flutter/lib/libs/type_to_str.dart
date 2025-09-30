import 'package:Kootumb/libs/str_utils.dart';
import 'package:Kootumb/models/community.dart';
import 'package:Kootumb/models/post.dart';
import 'package:Kootumb/models/post_comment.dart';
import 'package:Kootumb/models/user.dart';

String modelTypeToString(dynamic modelInstance, {bool capitalize = false}) {
  String result;
  if (modelInstance is Post) {
    result = 'post';
  } else if (modelInstance is PostComment) {
    result = 'post comment';
  } else if (modelInstance is Community) {
    result = 'community';
  } else if (modelInstance is User) {
    result = 'user';
  } else {
    result = 'item';
  }

  return capitalize ? toCapital(result) : result;
}
