import 'package:evgeshayoga/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserProviderModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User _user;
  String _userUid;

  User get user => _user;
  String get userUid => _userUid;

  void setUser(String uid, User user) {
    _user = user;
    _userUid = uid;
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void logout() {
    _user = null;
    _userUid = null;
    _auth.signOut();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}
