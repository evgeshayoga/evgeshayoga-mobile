import 'package:evgeshayoga/utils/animation.dart';
import 'package:evgeshayoga/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'login_screen.dart';

class Home extends StatelessWidget {
  Home({required AnimationController controller})
      : animation = HomeAnimation(controller);

  final HomeAnimation animation;
  static const int tabletBreakpoint = 600;

  Widget _buildHomeLayout(BuildContext context, bool isLandscape) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                child: Opacity(
                  opacity: animation.bgdropOpacity.value,
                  child: Image.asset('assets/images/photo_3_portrait.jpg',
                      alignment: Alignment(0, 0.7), fit: BoxFit.cover),
                ),
              ),
              Container(
                margin: isLandscape
                    ? EdgeInsets.fromLTRB(0, 0, 0, 13)
                    : EdgeInsets.fromLTRB(0, 0, 0, 30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Container(
//                  flex: 1,
//                    alignment: Alignment.bottomLeft,
//                    margin: const EdgeInsets.fromLTRB(60, 0, 0, 30),
                      child: new MaterialButton(
                        minWidth: 120,
                        onPressed: () {
                          var router = new MaterialPageRoute(
                              builder: (BuildContext context) {
                            return Login();
                          });
                          Navigator.of(context).push(router);
                        },
                        color: Style.pinkMain,
                        child: new Text(
                          "Вход",
                          style: Style.regularTextStyle,
                        ),
                      ),
                    ),
                    new Container(
//                  flex: 1,
//                  alignment: Alignment.bottomLeft,
//                  margin: const EdgeInsets.fromLTRB(100, 0, 0, 30),
                      child: new MaterialButton(
                        minWidth: 120,
                        color: Style.pinkMain,
                        onPressed: () async {
                          var url = 'https://evgeshayoga.com/register';
                          if (await canLaunch(url)) {
                            await launch(url);
                          }
                        },
                        child: new Text(
                          "Регистрация",
                          style: Style.regularTextStyle,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                alignment: isLandscape ? Alignment.topRight : Alignment.topCenter,
                margin: isLandscape
                    ? EdgeInsets.fromLTRB(0, 70, 70, 0)
                    : EdgeInsets.only(top: 70),
                child: Column(
                  children: <Widget>[
                    Text(
                      'ЙОГА С ЖЕНЕЙ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "BebasNeue",
                        fontSize: 30 * animation.titleSize.value,
                        fontWeight: FontWeight.w800,
//                      letterSpacing: 0,
                        color: Style.blueGrey
                            .withOpacity(animation.titleOpacity.value),
                      ),
                    ),
                    Text(
                      'СВОБОДА В ДВИЖЕНИИ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "BebasNeue",
                        fontSize: 20 * animation.titleSize.value,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.5,
                        color: Style.blueGrey
                            .withOpacity(animation.titleOpacity.value),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    var orientation = MediaQuery.of(context).orientation;

    var isLandscape = true;
    if (orientation == Orientation.portrait &&
        shortestSide < tabletBreakpoint) {
      isLandscape = false;
    }

    return AnimatedBuilder(
      animation: animation.controller,
      builder: (BuildContext context, Widget? child) =>
          _buildHomeLayout(context, isLandscape),
    );
  }
}
