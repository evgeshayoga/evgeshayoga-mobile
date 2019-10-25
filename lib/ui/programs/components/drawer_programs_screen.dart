import 'package:evgeshayoga/models/user.dart';
import 'package:evgeshayoga/ui/profile_screen.dart';
import 'package:evgeshayoga/ui/purchases_screen.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


Widget drawerProgramScreen(User user, context, userUid, isLandscape){
  final FirebaseAuth _auth = FirebaseAuth.instance;

  return Drawer(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              color: Style.pinkMain,
              alignment: Alignment.center,
              child: Center(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      contentPadding: EdgeInsets.only(top: 25),
                      title: isLandscape
                          ? Text("")
                          : CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Image.asset(
                          'assets/images/avatar.png',
                          height: 75,
                        ),
                        minRadius: 60,
                      ),
                    ),
                    Text(user.userName, style: Style.headerTextStyle,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    "Профиль",
                    textAlign: TextAlign.center,
                    style: Style.regularTextStyle,
                  ),
                  onTap: () {
                    var router =
                    new MaterialPageRoute(builder: (BuildContext context) {
                      return ProfileScreen(user);
                    });
                    Navigator.of(context).push(router);
                  },
                ),
                ListTile(
                  title: Text(
                    "Мои покупки",
                    textAlign: TextAlign.center,
                    style: Style.regularTextStyle,
                  ),
                  onTap: () {
                    var router =
                    new MaterialPageRoute(builder: (BuildContext context) {
                      return PurchasesScreen(userUid);
                    });
                    Navigator.of(context).push(router);
                  },
                )
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: RaisedButton(
                onPressed: () {
                  _auth.signOut();
                  Navigator.pushReplacementNamed(context, '/home');
                },
                color: Style.pinkMain,
                child: new Text("Выйти", style: Style.regularTextStyle,
                ),
              ),
            ),
          )
        ],
      ));
}