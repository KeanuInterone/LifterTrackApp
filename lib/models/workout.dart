import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:lifter_track_app/models/api.dart';
import 'package:lifter_track_app/models/exercise.dart';
import 'package:lifter_track_app/models/response.dart';
import 'package:lifter_track_app/models/set.dart';
import 'package:lifter_track_app/models/set_group.dart';

class Workout {
  String id;
  DateTime startTime;
  List<SetGroup> setGroups;

  Workout({this.id, this.setGroups, this.startTime});

  factory Workout.fromJson(Map<String, dynamic> json) {
    List<SetGroup> setGroups = [];
    for (Map<String, dynamic> setGroupJson in json['set_groups']) {
      setGroups.add(SetGroup.fromJson(setGroupJson)); 
    }
    return Workout(id: json['_id'], setGroups: setGroups, startTime: DateTime.parse(json['start_time']));
  }

  static Future<Response> create() async {
    String url = "${API.baseURL}/workouts/create";
    Uri uri = Uri.parse(url);
    var response = await http.post(
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
          hasError ? json['error'] : "There was an error creating the workout",
          null);
    }

    Map<String, dynamic> json = jsonDecode(response.body);
    Workout workout = Workout.fromJson(json);
    return Response(true, null, workout);
  }

  Future<Response> createSetGroup(Exercise exercise) async {
    String url = "${API.baseURL}/workouts/$id/add_set_group";
    Uri uri = Uri.parse(url);
    var response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${API.authToken}'
      },
      body: jsonEncode({'focus_exercise': exercise.id}),
    );
    if (response.statusCode != 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      bool hasError = json != null && json.containsKey('error');
      return Response(
          false,
          hasError ? json['error'] : "There was an error creating the workout",
          null);
    }

    Map<String, dynamic> json = jsonDecode(response.body);
    SetGroup setGroup = SetGroup.fromJson(json);
    setGroups.add(setGroup);
    return Response(true, null, setGroup);
  }

  Future<Response> createSet(
      SetGroup setGroup, Exercise exercise, int weight, int reps) async {
    String url = "${API.baseURL}/workouts/$id/add_set";
    Uri uri = Uri.parse(url);
    var response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${API.authToken}'
      },
      body: jsonEncode({
        'exercise_id': exercise.id,
        'set_group_id': setGroup.id,
        'weight': weight,
        'reps': reps
      }),
    );
    if (response.statusCode != 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      bool hasError = json != null && json.containsKey('error');
      return Response(
          false,
          hasError ? json['error'] : "There was an error creating the workout",
          null);
    }

    Map<String, dynamic> json = jsonDecode(response.body);
    Set set = Set.fromJson(json);
    set.exercise = exercise;
    setGroup.sets.add(set);
    return Response(true, null, set);
  }

  Future<Response> finish() async {
    String url = "${API.baseURL}/workouts/$id/finish";
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
          hasError ? json['error'] : "There was an error finishing the workout",
          null);
    }
    
    return Response(true, null, true);
  }



  static Future<Response> getLatestWorkouts() async {
    Response res = await API.makeApiRequest(path: 'workouts');
    if (res.success) {
      List<Workout> workouts = [];
      for (Map<String, dynamic> json in res.data) {
        workouts.add(Workout.fromJson(json));
      }
      res.data = workouts;
    }
    return res;

  }

  


}
