import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> getUserSubscriptionStatus(String uid) async {
  if (uid == null) {
    return new Map();
  }
  var response = await http.get(
    "https://evgeshayoga.com/api/users/" + uid + "/videos",
  );
  Map<String, dynamic> data = json.decode(response.body);

  String error = data["error"];
  if (error != null) {
    throw new Exception(error);
  }
  return data;
}
Future<Map<String, dynamic>> getUserProgramsStatuses(String uid) async {
  if (uid == null) {
    return new Map();
  }
  var response = await http.get(
    "https://evgeshayoga.com/api/users/" + uid + "/marathons",
  );
  Map<String, dynamic> data = json.decode(response.body);
  String error = data["error"];
  if (error != null) {
    throw new Exception(error);
  }
  return data;
}
