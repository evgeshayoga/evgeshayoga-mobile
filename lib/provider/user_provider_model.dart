import 'package:evgeshayoga/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class UserProviderModel extends ChangeNotifier {
  final AuthAdapter authAdapter;
  User? _user;
  String? _userUid;

  User? get user => _user;

  String? get userUid => _userUid;

  UserProviderModel(this.authAdapter);

  Future login(String uid) {
    return authAdapter.login(uid).then((value)  {
      _user = value;
      _userUid = uid;
      // This call tells the widgets that are listening to this model to rebuild.
      notifyListeners();
    });
  }

  void logout() {
    _user = null;
    _userUid = null;
    authAdapter.logout();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}

abstract class AuthAdapter {
  void logout();

  Future<User> login(String uid);
}

class FirebaseAuthAdapter implements AuthAdapter {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;

  @override
  Future<User> login(String uid) async {
    DatabaseReference dbUsersReference =
    database.reference().child("users").child(uid);
    var userSnapshot = await dbUsersReference.once();
    var decodedUser = User.fromSnapshot(userSnapshot);

    return decodedUser;
  }

  @override
  void logout() {
    _auth.signOut();
  }

}
