import 'package:evgeshayoga/models/user.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

final profileUrl = Uri.parse('https://evgeshayoga.com/profile/payment');

class ProfileScreen extends StatelessWidget {
  final User user;

  @override
  ProfileScreen(this.user, {Key? key}) : super(key: key);

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
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                "Управление личным кабинетом и подпиской Йога-онлайн доступно только на нашем сайте evgeshayoga.com",
                style: Style.regularTextStyle,
              ),
            ),
            OutlinedButton(
              onPressed: () async {
                await launchUrl(profileUrl);
              },
              // color: Style.pinkMain,
              child: new Text(
                "Перейти на сайт",
                style: Style.regularTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
