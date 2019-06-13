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
//        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Image.asset(
          'assets/images/logo.png',
          height: 40,
        ),
        centerTitle: true,
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                user.userName,
                style: Style.header2TextStyle,
              ),
              Text(
                user.userEmail,
                style: Style.regularTextStyle,
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
