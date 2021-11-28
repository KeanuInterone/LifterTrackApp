class Exercise {
  String id;
  String name;
  Exercise({this.id, this.name});
  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(id: json['_id'], name: json['name']);
  }
}
