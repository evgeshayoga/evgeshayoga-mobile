import 'package:evgeshayoga/models/user.dart';
import 'package:evgeshayoga/ui/profile_screen.dart';
import 'package:evgeshayoga/ui/programs/components/subscription_screen.dart';
import 'package:evgeshayoga/ui/programs/programs_screen.dart';
import 'package:evgeshayoga/ui/programs/yoga_online_screen.dart';
import 'package:evgeshayoga/ui/purchases_screen.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Widget drawerProgramScreen(User user, context, userUid, isLandscape, version, buildNumber) {
Widget drawerProgramScreen(User user, context, userUid, isLandscape, version, buildNumber) {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  return Drawer(
    child: SafeArea(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: isLandscape ? 1 : 3,
            child: Container(
              color: Style.pinkMain,
              child: Center(
                child: Container(
                  child: ListTile(
                    title: isLandscape
                        ? Text("")
                        : CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Image.asset(
                              'assets/images/avatar.png',
                              height: 75,
                            ),
                            minRadius: 40,
                            maxRadius: 75,
                          ),
                    subtitle: Padding(
                      padding: isLandscape
                          ? const EdgeInsets.only(top: 0.0)
                          : const EdgeInsets.only(top: 10.0),
                      child: Text(
                        user.userName,
                        style: Style.headerTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 0),
          ),
          Expanded(
            flex: 3,
            child: ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "Профиль",
                        textAlign: TextAlign.center,
                        style: Style.regularTextStyle,
                      ),
                      onTap: () {
                        var router = new MaterialPageRoute(
                            builder: (BuildContext context) {
                          return ProfileScreen(user);
                        });
                        Navigator.of(context).push(router);
                      },
                    ),
                    ListTile(
                      title: Text(
                        "Yoga Online",
                        textAlign: TextAlign.center,
                        style: Style.regularTextStyle,
                      ),
                      onTap: () {
                        var router = new MaterialPageRoute(
                            builder: (BuildContext context) {
                          return YogaOnlineScreen(userUid: userUid);
                        });
                        Navigator.of(context).push(router);
                      },
                    ),
                    ListTile(
                      title: Text(
                        "Программы",
                        textAlign: TextAlign.center,
                        style: Style.regularTextStyle,
                      ),
                      onTap: () {
                        var router = new MaterialPageRoute(
                            builder: (BuildContext context) {
                          return Programs(userUid: userUid);
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
                        var router = new MaterialPageRoute(
                            builder: (BuildContext context) {
                          return PurchasesScreen(userUid);
                        });
                        Navigator.of(context).push(router);
                      },
                    ),
                    ListTile(
                      title: Text(
                        "Подписка Yoga Online",
                        textAlign: TextAlign.center,
                        style: Style.regularTextStyle,
                      ),
                      onTap: () {
                        var router = new MaterialPageRoute(
                            builder: (BuildContext context) {
                          return SubscriptionScreen(userUid);
                        });
                        Navigator.of(context).push(router);
                      },
                    )
                  ],
                ),
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
                child: new Text(
                  "Выйти",
                  style: Style.regularTextStyle,
                ),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                version + "+" +buildNumber,
                style: TextStyle(fontSize: 9, color: Style.lightBlue),
              ),
            ),
          )
        ],
      ),
    ),
  );
}
