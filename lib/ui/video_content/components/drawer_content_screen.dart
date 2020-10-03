import 'package:evgeshayoga/models/user.dart';
import 'package:evgeshayoga/provider/info_provider_model.dart';
import 'package:evgeshayoga/provider/user_provider_model.dart';
import 'package:evgeshayoga/ui/profile_screen.dart';
import 'package:evgeshayoga/ui/subscription_screen.dart';
import 'package:evgeshayoga/ui/video_content/programs_screen.dart';
import 'package:evgeshayoga/ui/video_content/yoga_online_screen.dart';
import 'package:evgeshayoga/ui/purchases_screen.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget drawerProgramScreen(bool isLandscape) {
  return Consumer<UserProviderModel>(
    builder: (context, userProvider, child) {
      User userData = userProvider.user ?? new User("", "", "", "");
      return Consumer<InfoProviderModel>(
        builder: (context, infoProvider, child) {
          String version = infoProvider.version ?? "";
          String buildNumber = infoProvider.buildNumber ?? "";
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
                                userData.userName,
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
                                      return ProfileScreen(userData);
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
                                      return YogaOnlineScreen(userUid: userProvider.userUid);
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
                                      return Programs(userUid: userProvider.userUid);
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
                                      return PurchasesScreen(userProvider.userUid);
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
                                      return SubscriptionScreen(userProvider.userUid);
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
                          userProvider.logout();
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
      );
    },
  );
}