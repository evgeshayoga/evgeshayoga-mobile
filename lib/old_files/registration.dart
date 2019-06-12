//import 'package:evgeshayoga/old_files/old_user.dart';
//import 'package:evgeshayoga/ui/login.dart';
//import 'package:flutter/material.dart';
//import 'package:evgeshayoga/utils/database_helper.dart';
//
//class Registration extends StatefulWidget {
//  @override
//  _RegistrationState createState() => _RegistrationState();
//}
//
//class _RegistrationState extends State<Registration> {
//  var db = new DatabaseHelper();
//  final TextEditingController _createEmailController =
//      new TextEditingController();
//  final TextEditingController _createPasswordController =
//      new TextEditingController();
//  final TextEditingController _repeatPasswordController =
//      new TextEditingController();
//  final TextEditingController _userName = new TextEditingController();
//  final TextEditingController _userFamilyName = new TextEditingController();
//  String _registrationAlert = "";
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        backgroundColor: Colors.green.shade400,
//        title: Text("Йога с Женей"),
//        centerTitle: true,
//      ),
//      body: Container(
//          margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
////        alignment: Alignment.bottomCenter,
//          child: Center(
////          crossAxisAlignment: CrossAxisAlignment.center,
//            child: new ListView(
////              height: 600.0,
////              width: 400.0,
////              color: Colors.white,
//              children: <Widget>[
//                new TextField(
//                  controller: _createEmailController,
//                  decoration: new InputDecoration(
//                      hintText: "Your email", icon: new Icon(Icons.email)),
//                ),
//                new TextField(
//                  controller: _createPasswordController,
//                  decoration: new InputDecoration(
//                      hintText: "Your password", icon: new Icon(Icons.lock)),
//                  obscureText: true,
//                ),
//                new TextField(
//                  controller: _repeatPasswordController,
//                  decoration: new InputDecoration(
//                      hintText: "Repeat password", icon: new Icon(Icons.lock)),
//                  obscureText: true,
//                ),
//                TextField(
//                  controller: _userName,
//                  decoration: new InputDecoration(
//                      hintText: "Enter your name", icon: Icon(Icons.person)),
//                ),
//                TextField(
//                  controller: _userFamilyName,
//                  decoration: new InputDecoration(
//                      hintText: "Enter your family name",
//                      icon: Icon(Icons.person_outline)),
//                ),
//                new Padding(padding: new EdgeInsets.all(10.5)),
//                new Center(
//                  child: new Row(
//                    children: <Widget>[
//                      new Container(
//                          margin: const EdgeInsets.only(left: 40.0),
//                          child: new RaisedButton(
//                              onPressed: _registerNewUser,
//                              color: Colors.white,
//                              child: new Text(
//                                "Create account",
//                                style: TextStyle(
//                                    color: Colors.black, fontSize: 16.9),
//                              ))),
//                    ],
//                  ),
//                ),
//                Text(
//                  "$_registrationAlert",
//                  style: TextStyle(color: Colors.red),
//                )
//              ],
//            ),
//          )),
//
//    );
//  }
//
//  _registerNewUser() async {
//    debugPrint("$_createPasswordController.text, $_repeatPasswordController.text");
//    if (_createPasswordController.text != _repeatPasswordController.text) {
//      setState(() {
//        _registrationAlert = "Введенные пароли не совпадают";
//      });
//      return null;
//    }
//
//    if (_createEmailController.text.isEmpty ||
//        _createPasswordController.text.isEmpty ||
//        _userName.text.isEmpty ||
//        _userFamilyName.text.isEmpty) {
//      setState(() {
//        _registrationAlert = "Проверьте введенные данные";
//      });
//      return null;
//    }
//
//    await createUser(_createEmailController.text, _createPasswordController.text,  _userName.text, _userFamilyName.text);
//
//    var router = new MaterialPageRoute(builder: (BuildContext context) {
//      return Login();
//    });
//    Navigator.of(context).push(router);
//
//  }
//  createUser(String email, String password, String name, String familyName) async {
//    User user = User(name, familyName, email, password, DateTime.now().toString());
//    int savedUser = await db.saveUser(user);
//    print("User saved $savedUser");
//  }
//
//}
//
