import 'dart:convert';
import 'package:evgeshayoga/models/user.dart';
import 'package:evgeshayoga/provider/info_provider_model.dart';
import 'package:evgeshayoga/provider/user_provider_model.dart';
import 'package:evgeshayoga/ui/video_content/yoga_online_screen.dart';
import 'package:evgeshayoga/utils/ProgressHUD.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
  final _loginFormKey = GlobalKey<FormState>();
  User user = User("", "", "", "", userId: 0);
  String? _loginAlert;
  bool _isInAsyncCall = false;
  bool _isTablet = false;

  void _showProgressIndicator() {
    FocusScope.of(context).requestFocus(new FocusNode());
    setState(() {
      _isInAsyncCall = true;
    });
  }

  static const int tabletBreakpoint = 600;

  Widget _buildLandscapeLayout() {
    return Container(
      color: Colors.white,
      child: ListView(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Container(
                  height: MediaQuery.of(context).size.shortestSide - 120,
                  child: Image.asset(
                    'assets/images/evgeshayoga_landscape.jpg',
                    fit: BoxFit.cover,
                    alignment: FractionalOffset.bottomRight,
                  ),
                ),
              ),
              Expanded(
                  flex: 5,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding:
                            const EdgeInsets.only(top: 20, right: 20, left: 20),
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
                                  decoration: const InputDecoration(
                                    icon: Icon(Icons.email),
                                    hintText: 'Введите свой email',
                                    labelText: 'Email',
                                  ),
                                  onSaved: (value) =>
                                      user.userEmail = value!.trim(),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Введите email';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    icon: Icon(Icons.lock),
                                    hintText: 'Введите свой пароль',
                                    labelText: 'Пароль',
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Введите пароль';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) =>
                                      user.password = value!.trim(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: userLogIn,
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
                        width: 200,
                        child: TextButton(
                          onPressed: () async {
                            var url = 'https://evgeshayoga.com/register';
                            if (await canLaunch(url)) {
                              await launch(url);
                            }
                          },
                          child: Text(
                            "Зарегестрироваться",
                            style: Style.regularTextStyle,
                          ),
                        ),
                      ),
                      Padding(padding: new EdgeInsets.all(10.5)),
                      Center(
                        child: _loginAlert == null
                            ? null
                            : Text(
                                _loginAlert!,
                                style: TextStyle(
                                  fontFamily: "Nunito",
                                  color: Colors.red,
                                ),
                              ),
                      ),
                    ],
                  ))
            ],
          ),

//          Padding(
//            padding: const EdgeInsets.only(top: 20.0),
//          ),
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
            height: _isTablet ? 400 : 240,
            child: Image.asset(
              'assets/images/evgeshayoga_landscape.jpg',
              fit: BoxFit.cover,
              alignment: FractionalOffset.bottomRight,
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
                      onSaved: (value) => user.userEmail = value!.trim(),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Введите email';
                        }
                        return null;
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
                        if (value!.isEmpty) {
                          return 'Введите пароль';
                        }
                        return null;
                      },
                      onSaved: (value) => user.password = value!.trim(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment(0.0, 0.0),
            child: Column(
              children: <Widget>[
                Container(
                  width: 250,
                  child: ElevatedButton(
                    onPressed: userLogIn,
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
                  width: 250,
                  child: TextButton(
                    onPressed: () async {
                      var url = 'https://evgeshayoga.com/register';
                      if (await canLaunch(url)) {
                        await launch(url);
                      }
                    },
                    child: Text(
                      "Зарегистрироваться",
                      style: Style.regularTextStyle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(padding: new EdgeInsets.all(10.5)),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: _loginAlert == null
                  ? null
                  : Text(
                      _loginAlert!,
                      style: TextStyle(color: Colors.red),
                    ),
            ),
          ),
          Consumer<InfoProviderModel>(builder: (context, infoProvider, child) {
            String version = infoProvider.version;
            String buildNumber = infoProvider.buildNumber;
            return Text(
                version + "+" + buildNumber,
                style: TextStyle(fontSize: 9, color: Style.lightBlue),

            );
          })
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
    if (shortestSide > tabletBreakpoint) {
      setState(() {
        _isTablet = true;
      });
    }

    if (orientation == Orientation.portrait) {
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
      body: _isInAsyncCall ? progressHUD(_isInAsyncCall) : loginPageContent,
    );
  }

  Future userLogIn() async {
    if (_loginFormKey.currentState!.validate()) {
      _loginFormKey.currentState!.save();
      _loginFormKey.currentState!.reset();
      try {
        _showProgressIndicator();
        var response = await http.post(
          Uri.https("evgeshayoga.com", "/api/auth"),
          body:
              json.encode({"email": user.userEmail, "password": user.password}),
          headers: {'Content-Type': 'application/json'},
        );
        Map<String, dynamic> data = json.decode(response.body);
        var error = data["error"];
        if (error != null) {
          throw new Exception(error);
        }
        fb.UserCredential result = await _auth.signInWithEmailAndPassword(
          email: user.userEmail,
          password: user.password,
        );
        fb.User? newUser = result.user;
        await Provider.of<UserProviderModel>(context, listen: false)
            .login(newUser!.uid);
        var router = new MaterialPageRoute(builder: (BuildContext context) {
          return YogaOnlineScreen(
            userUid: newUser.uid,
          );
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
