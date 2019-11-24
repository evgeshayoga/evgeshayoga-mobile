import 'dart:convert';

import 'package:evgeshayoga/models/user.dart';
import 'package:evgeshayoga/ui/programs/programs_screen.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:url_launcher/url_launcher.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  DatabaseReference databaseReference;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _loginFormKey = GlobalKey<FormState>();
  User user = User("", "", "", "");
  String _loginAlert = "";

//  bool _saving = false;
  bool _isInAsyncCall = false;

  void _showProgressIndicator() {
    FocusScope.of(context).requestFocus(new FocusNode());
    setState(() {
      _isInAsyncCall = true;
    });

    //Simulate a service call
//    new Future.delayed(
//        new Duration(seconds: 4),() {
//      setState(() {
//        _saving = false;
//      });
//    });
  }

  static const int tabletBreakpoint = 600;

  Widget _buildLandscapeLayout() {
    return Container(
      color: Colors.white,
      child: ListView(
        children: <Widget>[
          Container(
            height: 240,
            child: Image.asset(
              'assets/images/evgeshayoga_landscape.jpg',
              fit: BoxFit.cover,
              height: 240,
              alignment: FractionalOffset.bottomCenter,
            ),
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
              _loginAlert,
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
          Container(
            height: 240,
            child: Image.asset(
              'assets/images/evgeshayoga_landscape.jpg',
            ),
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
                "Зарегистрироваться",
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
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                _loginAlert,
                style: TextStyle(color: Colors.red),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          'assets/images/logo.png',
          alignment: Alignment.center,
          fit: BoxFit.contain,
          repeat: ImageRepeat.noRepeat,
          height: 35,
        ),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        color: Colors.white,
        child: SafeArea(child: loginPageContent),
        inAsyncCall: _isInAsyncCall,
        opacity: 0.5,
        progressIndicator: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Style.pinkMain),
        ),
      ),
    );
  }

  Future userLogIn() async {
    if (_loginFormKey.currentState.validate()) {
      _loginFormKey.currentState.save();
      _loginFormKey.currentState.reset();
      try {
        _showProgressIndicator();
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
        FirebaseUser newUser = (await _auth.signInWithEmailAndPassword(
          email: user.userEmail,
          password: user.password,
        ))
            .user;
        var router = new MaterialPageRoute(builder: (BuildContext context) {
          return Programs(userUid: newUser.uid);
        });
        Navigator.of(context).push(router);
      } on PlatformException catch (e) {
        print("platform exception");
        print(e.toString());
        setState(() {
          _loginAlert = e.message;
          _isInAsyncCall = false;
        });
      } on Exception catch (e) {
        print("exception");
        print(e.toString());
        setState(() {
          _loginAlert = e.toString();
          _isInAsyncCall = false;
        });
      }
    }
  }
}
