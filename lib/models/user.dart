import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

class User {
  int userId;
  String userName;
  String userEmail;
  String password;
  String phoneNumber;
  UserPurchases purchases;

  User(this.userName, this.userEmail, this.password, this.phoneNumber,
      {this.userId, this.purchases});

  User.fromSnapshot(DataSnapshot snapshot)
      : userId = snapshot.value["id"],
        userName = snapshot.value["name"],
        userEmail = snapshot.value["email"],
        phoneNumber = snapshot.value["phone"],
        purchases = new UserPurchases(snapshot.value["purchases"]);

  UserPurchases getPurchases() {
    return purchases != null ? purchases : new UserPurchases({});
  }

  toJson() {
    return {
      "id": userId,
      "name": userName,
      "email": userEmail,
      "phone": phoneNumber,
      "purchases": purchases
    };
  }
}

class UserPurchases {
  Map<int, dynamic> programs;

  UserPurchases(Map<dynamic, dynamic> dbData) {
    this.programs = {};
    List userPrograms = dbData["marathons"];
    if (userPrograms != null) {
      userPrograms.forEach((purchase) {
        this.programs[purchase["id"]] = purchase;
      });
    }
  }



}
