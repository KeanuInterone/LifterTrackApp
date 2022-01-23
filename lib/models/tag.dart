import 'dart:convert';

import 'package:lifter_track_app/models/api.dart';
import 'package:lifter_track_app/models/response.dart';
import 'package:http/http.dart' as http;

class Tag {
  String id;
  String name;
  Tag({this.id, this.name});
  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['_id'],
      name: json['name'],
    );
  }

  static Future<Response> createTag(Tag tag) async {
    String url = "${API.baseURL}/tags/create";
    Uri uri = Uri.parse(url);
    var response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${API.authToken}'
      },
      body: jsonEncode({'name': tag.name})
    );
    if (response.statusCode != 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      bool hasError = json != null && json.containsKey('error');
      return Response(
          false,
          hasError ? json['error'] : "There was an error creating the tag",
          null);
    }

    Map<String, dynamic> json = jsonDecode(response.body);
    tag = Tag.fromJson(json);
    
    return Response(true, null, tag);
  }

  static Future<Response> getTags() async {
    String url = "${API.baseURL}/tags";
    Uri uri = Uri.parse(url);
    var response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${API.authToken}'
      },
    );
    if (response.statusCode != 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      bool hasError = json != null && json.containsKey('error');
      return Response(
          false,
          hasError ? json['error'] : "There was an error creating the user",
          null);
    }

    List<dynamic> json = jsonDecode(response.body);
    List<Tag> tagsList = [];
    json.forEach((tagJson) {
      tagsList.add(Tag.fromJson(tagJson));
    });
    return Response(true, null, tagsList);
  }
}
