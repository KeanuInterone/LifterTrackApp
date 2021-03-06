import 'dart:convert';
import 'package:lifter_track_app/models/api.dart';
import 'package:lifter_track_app/models/exercise.dart';
import 'package:lifter_track_app/models/response.dart';
import 'package:http/http.dart' as http;

class Set {
  String id;
  String exerciseId;
  Exercise exercise;
  int weight;
  int reps;
  Set({this.id, this.exerciseId, this.exercise, this.weight, this.reps});
  factory Set.fromJson(Map<String, dynamic> json) {
    Exercise exercise;
    String exerciseId;
    if (json['exercise'] is Map<String, dynamic>) {
      exercise = Exercise.fromJson(json['exercise']);
      exerciseId = exercise.id;
    } else {
      exerciseId = json['exercise'];
    }

    return Set(
      id: json['_id'],
      exerciseId: exerciseId,
      exercise: exercise,
      weight: json['weight'],
      reps: json['reps'],
    );
  }

  Future<Response> update(int weight, int reps) async {
    Response res = await API.makeApiRequest(
      path: 'sets/$id/edit',
      method: HttpMethod.post,
      body: jsonEncode({'weight': weight, 'reps': reps}),
    );
    if (res.success) {
      this.weight = weight;
      this.reps = reps;
      res.data = this;
    }
    return res;
  }

  Future<Response> delete() async {
    Response res = await API.makeApiRequest(
      path: 'sets/$id/delete',
      method: HttpMethod.delete,
    );
    return res;
  }
}
