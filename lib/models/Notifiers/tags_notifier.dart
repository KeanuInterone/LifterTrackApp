import 'package:flutter/foundation.dart';
import 'package:lifter_track_app/models/response.dart';
import 'package:lifter_track_app/models/tag.dart';

class TagsNotifier extends ChangeNotifier {
  List<Tag> tags = [];
  Map<String, Tag> tagWithId = {};

  Future<Response> getTags() async {
    Response res = await Tag.getTags();
    if (!res.success) return res;
    tags = res.data;
    tagWithId = {};
    for (Tag tag in tags) {
      tagWithId[tag.id] = tag;
    }
    notifyListeners();
    return res;
  }

  Future<Response> addTag(Tag tag) async {
    Response res = await Tag.createTag(tag);
    if (res.success) {
      tag = res.data;
      tags.add(tag);
      tagWithId[tag.id] = tag;
      notifyListeners();
    }
    return res;
  }

  clear() {
    tags = [];
    tagWithId = {};
    notifyListeners();
  }

}