import 'package:evgeshayoga/models/user.dart';
import 'package:evgeshayoga/ui/programs.dart';
import 'package:evgeshayoga/utils/date_formatter.dart';
import 'package:evgeshayoga/ui/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/services.dart' show PlatformException;

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignin = GoogleSignIn();

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  final _registrationFormKey = GlobalKey<FormState>();
  User user = new User("", "", "", "", "", "");

  DatabaseReference databaseReference;
  String alertString = "";

  @override
  void initState() {
    super.initState();
    databaseReference = database.reference().child("Users");
    print("init ref");
  }

  Future _createUser() async {
    setState(() {
      alertString = "";
    });
    if (_registrationFormKey.currentState.validate()) {
      _registrationFormKey.currentState.save();
      print("_createUser ${user.userEmail} , ${user.password}");
      try {
        var firebaseUser = await _auth.createUserWithEmailAndPassword(
          email: "${user.userEmail}",
          password: "${user.password}",
        );
        user.dateCreated = dateFormatted();
        print("Created user ${firebaseUser.uid} ${firebaseUser.displayName}");
        print("Email ${firebaseUser.email}");
        await databaseReference.child(firebaseUser.uid).set(user.toJson());

        var router = new MaterialPageRoute(builder: (BuildContext context) {
          return Programs(
            userUid: firebaseUser.uid,
          );
        });
        Navigator.of(context).push(router);
      } on PlatformException catch (e) {
        setState(() {
          alertString = e.message;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade400,
        title: Text("Йога с Женей"),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Center(
            child: Form(
              key: _registrationFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.email),
                      hintText: 'Enter your Email',
                      labelText: 'Email',
                    ),
                    onSaved: (value) => user.userEmail = value.trim(),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your email';
                      }
                    },
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.lock),
                      hintText: 'Enter your password',
                      labelText: 'Password',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your password';
                      }
                    },
                    onSaved: (value) => user.password = value.trim(),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      hintText: 'Enter your name',
                      labelText: 'Name',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your name';
                      }
                    },
                    onSaved: (value) => user.userName = value,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      hintText: 'Enter your family name',
                      labelText: 'Family Name',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your family name';
                      }
                    },
                    onSaved: (value) => user.userFamilyName = value,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                  ),
                  Center(
                    child: RaisedButton(
                      child: Text("Register"),
                      onPressed: () {
                        _createUser();
                      },
                    ),
                  ),
                  Text(
                    "$alertString",
                    style: TextStyle(color: Colors.red),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
