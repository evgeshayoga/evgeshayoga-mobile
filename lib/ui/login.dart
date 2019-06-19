import 'package:evgeshayoga/models/user.dart';
import 'package:evgeshayoga/ui/programs.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart' show PlatformException;
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:progress_hud/progress_hud.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  DatabaseReference databaseReference;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignin = GoogleSignIn();
  final _loginFormKey = GlobalKey<FormState>();
  User user = User("", "", "", "");
  String loginAlert = "";
  ProgressHUD _progressHUD;
  bool _loading = true;


  static const int tabletBreakpoint = 600;

  Widget _buildLandscapeLayout() {
    return Container(
      color: Colors.white,
      child: ListView(
        children: <Widget>[
          Image.asset(
            'assets/images/evgeshayoga_landscape.jpg',
            fit: BoxFit.cover,
            height: 240,
            alignment: FractionalOffset.bottomCenter,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
          ),
          Container(
            height: 170,
            alignment: Alignment(0.0, 0.0),
            color: Colors.white,
            child: Container(
              width: 500,
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
            margin: const EdgeInsets.only(left: 150, right: 150),
            child: RaisedButton(
              onPressed: userLogIn,
              color: Color.fromRGBO(242, 206, 210, .75),
              child: Text(
                "Войти",
                style: Style.regularTextStyle,
              ),
            ),
          ),
          Text(
            "или",
            textAlign: TextAlign.center,
            style: Style.regularTextStyle,
          ),
          Container(
            margin: const EdgeInsets.only(left: 150, right: 150),
            child: RaisedButton(
              onPressed: () async {
                var url = 'https://evgeshayoga.com/register';
                if (await canLaunch(url)) {
                  await launch(url);
                }
              },
              color: Color.fromRGBO(242, 206, 210, .75),
              child: Text(
                "Зарегестрироваться",
                style: Style.regularTextStyle,
              ),
            ),
          ),
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
              style: TextStyle(
                fontFamily: "Nunito",
                color: Colors.red,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPortraitLayout() {
    return Container(
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
              color: Style.pinkMain,
              child: Text(
                "Войти",
                style: Style.regularTextStyle,
              ),
            ),
          ),
          Text(
            "или",
            textAlign: TextAlign.center,
            style: Style.regularTextStyle,
          ),
          Container(
            margin: const EdgeInsets.only(left: 50, right: 50),
            child: RaisedButton(
              onPressed: () async {
                var url = 'https://evgeshayoga.com/register';
                if (await canLaunch(url)) {
                  await launch(url);
                }
              },
              color: Style.pinkMain,
              child: Text(
                "Зарегестрироваться",
                style: Style.regularTextStyle,
              ),
            ),
          ),
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
    );
  }


  @override
  void initState() {
    super.initState();
    _progressHUD = new ProgressHUD(
      backgroundColor: Colors.black12,
      color: Colors.white,
      containerColor: Colors.blue,
      borderRadius: 5.0,
      text: 'Loading...',
    );
  }

  @override
  Widget build(BuildContext context) {

    void dismissProgressHUD() {
      setState(() {
        if (_loading) {
          _progressHUD.state.dismiss();
        } else {
          _progressHUD.state.show();
        }
        _loading = !_loading;
      });
    }

    Widget loginPageContent;
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    var orientation = MediaQuery.of(context).orientation;

    if (orientation == Orientation.portrait &&
        shortestSide < tabletBreakpoint) {
      loginPageContent = _buildPortraitLayout();
    } else {
      loginPageContent = _buildLandscapeLayout();
    }

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return BackButton(
              color: Style.blueGrey,
            );
          },
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Image.asset(
          'assets/images/logo.png', alignment: Alignment.center, fit: BoxFit.contain, repeat: ImageRepeat.noRepeat,
          height: 35,
        ),
        centerTitle: true,
      ),
      body: loginPageContent,
    );
  }

  Future userLogIn() async {
    if (_loginFormKey.currentState.validate()) {
      _loginFormKey.currentState.save();
      _loginFormKey.currentState.reset();
      try {
        var response = await http.post(
          "https://evgeshayoga.com/api/auth",
          body:
              json.encode({"email": user.userEmail, "password": user.password}),
          headers: {'Content-Type': 'application/json'},
        );
        Map<String, dynamic> data = json.decode(response.body);
        String error = data["error"];
        if (error != null) {
          throw new Exception(error);
        }
//        var newUser = await _auth.signInWithCustomToken(token: "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJmaXJlYmFzZS1hZG1pbnNkay1vbGhlOUBldmdlc2hheW9nYS1iYTM5Ny5pYW0uZ3NlcnZpY2VhY2NvdW50LmNvbSIsInN1YiI6ImZpcmViYXNlLWFkbWluc2RrLW9saGU5QGV2Z2VzaGF5b2dhLWJhMzk3LmlhbS5nc2VydmljZWFjY291bnQuY29tIiwiYXVkIjoiaHR0cHM6XC9cL2lkZW50aXR5dG9vbGtpdC5nb29nbGVhcGlzLmNvbVwvZ29vZ2xlLmlkZW50aXR5LmlkZW50aXR5dG9vbGtpdC52MS5JZGVudGl0eVRvb2xraXQiLCJ1aWQiOiJwaHAwMDAwMDE2MiIsImlhdCI6MTU1ODM3ODg5MCwiZXhwIjoxNTU4MzgyNDkwfQ.Dp7TALS9yODHkvqYNx9YjVyR39rxMzLB7N1j7vtNEZVKIPm4384TGJ3RQs5ubLZmTvKTeEq-RB7EXlC0o2H2qt0tciZj5TTZG6ZJ_FDtjz3TsQXB9-R99KFNnyebRuqCtuoCj_rhzT95_IHEdVGFkaum0rE64Gtvh0s_9bMdKwYVE08MM5ZwBFzsnxc-dDHG6deMCZbNjANC5ntndZnYTdMyLTusu80WrAfB9kJJRZU5W9Kj-PLkV832CoymyDEy2kZUI5KQWwBDERw4EdQl0TGMjcNdUL9vL5d09sIBouFJYuhI9BCfQ8lsQzDzwWR9fOonwtQ12Wmw2LPZPEPzyA");
        var newUser = await _auth.signInWithEmailAndPassword(
          email: user.userEmail,
          password: user.password,
        );

        var router = new MaterialPageRoute(builder: (BuildContext context) {
          return Programs(userUid: newUser.uid);
        });
        Navigator.of(context).push(router);
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

// Sign-in with email
  _signInWithEmail() {
    _auth
        .signInWithEmailAndPassword(
            email: user.userEmail, password: user.password)
        .catchError((error) {
      print("Something went wrong! ${error.toString()}");
    }).then((newUser) {
      print("User signed in: ${newUser.email}");
    });
  }
}