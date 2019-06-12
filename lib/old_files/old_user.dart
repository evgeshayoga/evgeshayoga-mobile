import 'package:firebase_database/firebase_database.dart';

class User {
  String key;
  String userName;
  String userFamilyName;
  String userEmail;
  String password;
  String dateCreated;

  User(this.key, this.userName, this.userFamilyName, this.userEmail,
      this.password, this.dateCreated);

  User.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        userName = snapshot.value["userName"],
        userFamilyName = snapshot.value["userFamilyName"],
        userEmail = snapshot.value["userEmail"],
        dateCreated = snapshot.value["dateCreated"];

  toJson() {
    return {
      "userName": userName,
      "userFamilyName": userFamilyName,
      "userEmail": userEmail,
      "dateCreated": dateCreated
    };
  }
}