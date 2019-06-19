import 'package:evgeshayoga/models/user.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  User user;

  @override
  ProfileScreen(this.user, {Key key}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return BackButton(
              color: Style.blueGrey,
            );
          },
        ),
        backgroundColor: Colors.white,
        title: Image.asset(
          'assets/images/logo.png',
          height: 40,
        ),
        centerTitle: true,
      ),
      backgroundColor: Style.pinkLight,
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                user.userName,
                style: Style.headerTextStyle,
              ),
              Padding(
                padding: EdgeInsets.all(8),
              ),
              Text(
                user.userEmail,
                style: Style.regularTextStyle,
              ),
              Padding(
                padding: EdgeInsets.all(8),
              ),
              Text(
                user.phoneNumber,
                style: Style.regularTextStyle,
              )
            ],
          )

      ),
    );
  }
}
