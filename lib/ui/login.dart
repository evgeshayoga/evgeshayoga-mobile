import 'package:evgeshayoga/models/user.dart';
import 'package:evgeshayoga/ui/marathons.dart';
import 'package:evgeshayoga/old_files/registration.dart';
import 'package:evgeshayoga/ui/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart' show PlatformException;
import 'package:url_launcher/url_launcher.dart';


//import 'package:evgeshayoga/utils/database_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
////  var db = new DatabaseHelper();
//  final TextEditingController _emailController = new TextEditingController();
//  final TextEditingController _passwordController = new TextEditingController();
  DatabaseReference databaseReference;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignin = GoogleSignIn();
  final _loginFormKey = GlobalKey<FormState>();
  User user = User("", "", "", "", "", "");
  String loginAlert = "";

//  void _erase() {
//    setState(() {
//      _emailController.clear();
//      _passwordController.clear();
//    });
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Image.asset(
          'assets/images/logo.png',
          height: 40,
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            Image.asset(
              'assets/images/evgeshayoga_landscape.jpg',
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
            ),
            Container(
              height: 170,
              alignment: Alignment(0.0, 0.0),
              color: Colors.white,
              child: Container(
                width: 300,
                child: Form(
                  key: _loginFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
//                          controller: _emailController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.email),
                          hintText: 'Введите свой email',
                          labelText: 'Email',
                        ),
                        onSaved: (value) => user.userEmail = value.trim(),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Введите email';
                          }
                        },
                      ),
                      TextFormField(
//                          controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.lock),
                          hintText: 'Введите свой пароль',
                          labelText: 'Пароль',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Введите пароль';
                          }
                        },
                        onSaved: (value) => user.password = value.trim(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(left: 50, right: 50),
                child: RaisedButton(
                    onPressed: userLogIn,
                    color: Color.fromRGBO(242, 206, 210, .75),
                    child: Text(
                      "Войти",
                      style: TextStyle(
                          color: Color.fromRGBO(94, 101, 111, 1),
                          fontSize: 16.9),
                    ))),
            Text(
              "или",
              textAlign: TextAlign.center,
              style: TextStyle(color: Color.fromRGBO(94, 101, 111, 1)),
            ),
            Container(
                margin: const EdgeInsets.only(left: 50, right: 50),
                child: RaisedButton(
                    onPressed:
                        () async {
                      var url = 'https://evgeshayoga.com/register';
                      if (await canLaunch(url)) {
                        await launch(url);
                      }
                    },
//                        () {
//                      var router = new MaterialPageRoute(
//                          builder: (BuildContext context) {
//                        return RegistrationPage();
//                      });
//                      Navigator.of(context).push(router);
//                    },
                    color: Color.fromRGBO(242, 206, 210, .75),
                    child: Text(
                      "Зарегестрироваться",
                      style: TextStyle(
                          color: Color.fromRGBO(94, 101, 111, 1),
                          fontSize: 16.9),
                    ))),
//            Center(
//                child: RaisedButton(
//                    onPressed: googleSignIn,
//                    color: Colors.white,
//                    child: Text(
//                      "Sign-in with Google",
//                      style: TextStyle(color: Colors.black, fontSize: 16.9),
//                    ))),
            Padding(padding: new EdgeInsets.all(10.5)),
            Center(
              child: Text(
                loginAlert,
                style: TextStyle(color: Colors.red),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future userLogIn() async {
    if (_loginFormKey.currentState.validate()) {
      _loginFormKey.currentState.save();
      _loginFormKey.currentState.reset();
      print("${user.userEmail}, ${user.password}");
      try {
        var response = await http.post(
          "https://evgeshayoga.com/api/jwt/auth",
          body:
              json.encode({"email": user.userEmail, "password": user.password}),
          headers: {'Content-type': 'application/json'},
        );
        Map<String, dynamic> data = json.decode(response.body);
        String token = data["token"];
        print(token);
//        var newUser = await _auth.signInWithCustomToken(token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJmaXJlYmFzZS1hZG1pbnNkay1vbGhlOUBldmdlc2hheW9nYS1iYTM5Ny5pYW0uZ3NlcnZpY2VhY2NvdW50LmNvbSIsInN1YiI6ImZpcmViYXNlLWFkbWluc2RrLW9saGU5QGV2Z2VzaGF5b2dhLWJhMzk3LmlhbS5nc2VydmljZWFjY291bnQuY29tIiwiYXVkIjoiaHR0cHM6XC9cL2lkZW50aXR5dG9vbGtpdC5nb29nbGVhcGlzLmNvbVwvZ29vZ2xlLmlkZW50aXR5LmlkZW50aXR5dG9vbGtpdC52MS5JZGVudGl0eVRvb2xraXQiLCJ1aWQiOiJwaHAwMDAwMDE2MiIsImlhdCI6MTU1ODM3ODg5MCwiZXhwIjoxNTU4MzgyNDkwfQ.Dp7TALS9yODHkvqYNx9YjVyR39rxMzLB7N1j7vtNEZVKIPm4384TGJ3RQs5ubLZmTvKTeEq-RB7EXlC0o2H2qt0tciZj5TTZG6ZJ_FDtjz3TsQXB9-R99KFNnyebRuqCtuoCj_rhzT95_IHEdVGFkaum0rE64Gtvh0s_9bMdKwYVE08MM5ZwBFzsnxc-dDHG6deMCZbNjANC5ntndZnYTdMyLTusu80WrAfB9kJJRZU5W9Kj-PLkV832CoymyDEy2kZUI5KQWwBDERw4EdQl0TGMjcNdUL9vL5d09sIBouFJYuhI9BCfQ8lsQzDzwWR9fOonwtQ12Wmw2LPZPEPzyA");
        var newUser = await _auth.signInWithCustomToken(token: token);

        print("User signed in: ${newUser.email}, ${newUser.uid}");
        var router = new MaterialPageRoute(builder: (BuildContext context) {
          return Marathons(name: user.userEmail, familyName: "test");
        });
        Navigator.of(context).push(router);
//        FirebaseDatabase.instance
//            .reference()
//            .child("Users")
//            .child(newUser.uid)
//            .once()
//            .then((DataSnapshot snapshot) {
//          Map<dynamic, dynamic> values = snapshot.value;
//          user.userName = values["userName"];
//          user.userFamilyName = values["userFamilyName"];
//          print(
//              "Sending Name ${user.userName} Sending Family Name ${user.userFamilyName}");
//
//          var router = new MaterialPageRoute(builder: (BuildContext context) {
//            return Marathons(
//                name: user.userName, familyName: user.userFamilyName);
//          });
//          Navigator.of(context).push(router);
//        });
      } on PlatformException catch (e) {
        print("platform exception");
        print(e.toString());
        setState(() {
          loginAlert = e.message;
        });
      } on Exception catch (e) {
        print("exception");
        print(e.toString());
        setState(() {
          loginAlert = e.toString();
        });
      }
    }
  }

// Sign-in with Google
  Future<FirebaseUser> googleSignIn() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignin.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken);
    FirebaseUser googleUser = await _auth.signInWithCredential(credential);
    print("User is ${googleUser.displayName}");
    var router = new MaterialPageRoute(builder: (BuildContext context) {
      return Marathons(name: googleUser.displayName, familyName: "");
    });
    Navigator.of(context).push(router);
  }
}

// OLD LOGIN
//  checkUser() async {
////    var allUsers = await db.getUsers();
////    print(allUsers);
////   await db.deleteUser(2);
//
//    String enteredEmail = _emailController.text.toString().trim();
//    String enteredPassword = _passwordController.text.toString().trim();
//
//    if (enteredEmail.isEmpty) {
//      setState(() {
//        loginAlert = "Email is empty";
//      });
//      return;
//    }
//    if (enteredPassword.isEmpty) {
//      setState(() {
//        loginAlert = "Password is empty";
//      });
//      return;
//    }
//    var user = await db.getUser(enteredEmail);
//    if (user == null) {
//      setState(() {
//        loginAlert = "No such user";
//      });
//      return;
//    }
//    if (user.password != enteredPassword) {
//      setState(() {
//        loginAlert = "Wrong password";
//      });
//      return;
//    }
//    var router = new MaterialPageRoute(builder: (BuildContext context) {
//      return Marathons(name: user.userName, familyName: user.userFamilyName);
//    });
//    Navigator.of(context).push(router);
//  }
