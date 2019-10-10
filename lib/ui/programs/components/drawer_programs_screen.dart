import 'package:evgeshayoga/models/user.dart';
import 'package:evgeshayoga/ui/profile_screen.dart';
import 'package:evgeshayoga/ui/purchases_screen.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


Widget drawerProgramScreen(User user, context, userUid){
  final FirebaseAuth _auth = FirebaseAuth.instance;

  return Drawer(
      child: new Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              //green container with user's icon and name
              Container(
                color: Color.fromRGBO(242, 206, 210, 1),
                alignment: Alignment.topCenter,
                height: 250,
                child: Center(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        contentPadding: EdgeInsets.fromLTRB(0, 60, 0, 0),
                        title: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Image.asset(
                            'assets/images/avatar.png',
                            height: 75,
                          ),
                          minRadius: 60,
                        ),
                      ),
                      Padding(padding: new EdgeInsets.fromLTRB(0, 0, 0, 0)),
                      Text(user.userName, style: Style.headerTextStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          Column(
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
                    return PurchasesScreen(user, userUid);
                  });
                  Navigator.of(context).push(router);
                },
              )
            ],
          ),
          Container(
            height: 250,
            alignment: Alignment.bottomCenter,
            child: RaisedButton(
              onPressed: () {
                _auth.signOut();
                Navigator.of(context).popUntil(ModalRoute.withName('/'));
              },
              color: Color.fromRGBO(242, 206, 210, 1),
              child: new Text("Logout", style: Style.regularTextStyle,
              ),
            ),
          )
        ],
      ));
}