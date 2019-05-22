import 'package:evgeshayoga/models/user.dart';
import 'package:evgeshayoga/ui/marathons.dart';
import 'package:evgeshayoga/old_files/registration.dart';
import 'package:evgeshayoga/ui/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart' show PlatformException;

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
        backgroundColor: Colors.green.shade400,
        title: Text("Йога с Женей"),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
//        alignment: Alignment.bottomCenter,
        child: ListView(
//          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/yoga_logo.png',
              height: 100,
              width: 100,
            ),
            new Container(
              color: Colors.white,
              child: new Column(
                children: <Widget>[
                  Form(
                    key: _loginFormKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
//                          controller: _emailController,
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
//                          controller: _passwordController,
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
                      ],
                    ),
                  ),
//
//                  new TextField(
//                    controller: _emailController,
//                    decoration: new InputDecoration(
//                        hintText: "Your email", icon: new Icon(Icons.email)),
//                  ),
//                  new TextField(
//                    controller: _passwordController,
//                    decoration: new InputDecoration(
//                        hintText: "Your password", icon: new Icon(Icons.lock)),
//                    obscureText: true,
//                  ),
                  new Padding(padding: new EdgeInsets.all(10.5)),
                  new Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          new Container(
                              margin: const EdgeInsets.only(left: 60.0),
                              child: new RaisedButton(
                                  onPressed: userLogIn,
                                  color: Colors.white,
                                  child: new Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16.9),
                                  ))),
                          new Container(
                            margin: const EdgeInsets.only(left: 100.0),
                            child: new RaisedButton(
                                onPressed: () {
                                  var router = new MaterialPageRoute(
                                      builder: (BuildContext context) {
                                    return RegistrationPage();
                                  });
                                  Navigator.of(context).push(router);
                                },
                                color: Colors.white,
                                child: new Text(
                                  "Register",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.9),
                                )),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
            ),
            Center(
                child: RaisedButton(
                    onPressed: googleSignIn,
                    color: Colors.white,
                    child: Text(
                      "Sign-in with Google",
                      style: TextStyle(color: Colors.black, fontSize: 16.9),
                    ))),
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
        var response = await http.post("https://evgeshayoga.com/api/jwt/auth",
            body: json.encode({"email": user.userEmail, "password": user.password}),
            headers: {'Content-type': 'application/json'},
        );
        Map<String, dynamic> data = json.decode(response.body);
        String token = data["token"];
        print(token);
//        var newUser = await _auth.signInWithCustomToken(token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJmaXJlYmFzZS1hZG1pbnNkay1vbGhlOUBldmdlc2hheW9nYS1iYTM5Ny5pYW0uZ3NlcnZpY2VhY2NvdW50LmNvbSIsInN1YiI6ImZpcmViYXNlLWFkbWluc2RrLW9saGU5QGV2Z2VzaGF5b2dhLWJhMzk3LmlhbS5nc2VydmljZWFjY291bnQuY29tIiwiYXVkIjoiaHR0cHM6XC9cL2lkZW50aXR5dG9vbGtpdC5nb29nbGVhcGlzLmNvbVwvZ29vZ2xlLmlkZW50aXR5LmlkZW50aXR5dG9vbGtpdC52MS5JZGVudGl0eVRvb2xraXQiLCJ1aWQiOiJwaHAwMDAwMDE2MiIsImlhdCI6MTU1ODM3ODg5MCwiZXhwIjoxNTU4MzgyNDkwfQ.Dp7TALS9yODHkvqYNx9YjVyR39rxMzLB7N1j7vtNEZVKIPm4384TGJ3RQs5ubLZmTvKTeEq-RB7EXlC0o2H2qt0tciZj5TTZG6ZJ_FDtjz3TsQXB9-R99KFNnyebRuqCtuoCj_rhzT95_IHEdVGFkaum0rE64Gtvh0s_9bMdKwYVE08MM5ZwBFzsnxc-dDHG6deMCZbNjANC5ntndZnYTdMyLTusu80WrAfB9kJJRZU5W9Kj-PLkV832CoymyDEy2kZUI5KQWwBDERw4EdQl0TGMjcNdUL9vL5d09sIBouFJYuhI9BCfQ8lsQzDzwWR9fOonwtQ12Wmw2LPZPEPzyA");
        var newUser = await _auth.signInWithCustomToken(token: token);

        print("User signed in: ${newUser.email}, ${newUser.uid}");
        var router = new MaterialPageRoute(builder: (BuildContext context) {
          return Marathons(
              name: user.userEmail, familyName: "test");
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
      } on Exception catch(e) {
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

