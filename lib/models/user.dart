import 'package:firebase_database/firebase_database.dart';

class User {
  int userId;
  String userName;
  String userEmail;
  String password;
  String phoneNumber;
  UserPurchases? purchases;

  User(this.userName, this.userEmail, this.password, this.phoneNumber,
      {required this.userId, this.purchases});

  User.fromSnapshot(DataSnapshot snapshot)
      : userId = snapshot.value["id"],
        userName = snapshot.value["name"],
        userEmail = snapshot.value["email"],
        phoneNumber = snapshot.value["phone"],
        purchases = new UserPurchases(snapshot.value["purchases"]),
        password = "";

  UserPurchases getPurchases() {
    return purchases != null ? purchases! : new UserPurchases({});
  }
}

class UserPurchases {
  Map<int, dynamic> programs = Map();

  UserPurchases(Map<dynamic, dynamic> dbData) {
    if (dbData == null) {
      return;
    }
    List userPrograms = dbData["marathons"];
    if (userPrograms != null) {
      userPrograms.forEach((purchase) {
        this.programs[purchase["id"]] = purchase;
      });
    }
  }
}
