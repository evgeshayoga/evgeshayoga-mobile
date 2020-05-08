import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> getUserSubscriptionStatus(String uid) async {
  var response = await http.get(
    "https://evgeshayoga.com/api/users/" + uid + "/videos",
  );
  Map<String, dynamic> data = json.decode(response.body);
  print(data);
  String error = data["error"];
  if (error != null) {
    throw new Exception(error);
  }
  return data;
}