import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class API {
  static String baseURL = "https://staging.api.liftertrack.com";
  static String authToken = "";

  static saveAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('authToken', authToken);
  }

  static loadAuthtoken() async {
    final prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('authToken');
  }

  static Future<bool> validateToken() async {
    if (authToken == null) return false;
    String url = '$baseURL/users/me';
    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $authToken'
      },
    );
    return response.statusCode == 200;
  }
}
