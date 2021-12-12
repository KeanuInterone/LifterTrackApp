import 'package:flutter/foundation.dart';
import 'package:lifter_track_app/models/response.dart';
import 'package:lifter_track_app/models/tag.dart';

class TagsNotifier extends ChangeNotifier {
  List<Tag> tags = [];

  Future<Response> getTags() async {
    Response res = await Tag.getTags();
    if (res.success) {
      tags = res.data;
    }
    notifyListeners();
    return res;
  }

  Future<Response> addTag(Tag tag) async {
    Response res = await Tag.createTag(tag);
    if (res.success) {
      tags.add(res.data);
      notifyListeners();
    }
    return res;
  }

}