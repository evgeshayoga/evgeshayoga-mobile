import 'package:firebase_database/firebase_database.dart';

class User {
  late int userId;
  late String userName;
  late String userEmail;
  late String password;
  late String phoneNumber;
  UserPurchases? purchases;

  User(this.userName, this.userEmail, this.password, this.phoneNumber,
      {required this.userId, this.purchases});

  User.fromSnapshot(DataSnapshot snapshot) {
    var data = new Map<String, dynamic>.from(snapshot.value as dynamic);
    userId = data["id"];
    userName = data["name"];
    userEmail = data["email"];
    phoneNumber = data["phone"];
    purchases = new UserPurchases(data["purchases"]);
    password = "";
  }

  UserPurchases getPurchases() {
    return purchases != null ? purchases! : new UserPurchases(null);
  }
}

class UserPurchases {
  Map<int, dynamic> programs = Map();

  UserPurchases(Map<dynamic, dynamic>? dbData) {
    if (dbData == null) {
      return;
    }
    List? userPrograms = dbData["marathons"];
    if (userPrograms != null) {
      userPrograms.forEach((purchase) {
        this.programs[purchase["id"]] = purchase;
      });
    }
  }
}
